import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:skill_swap/shared/common_ui/video_call/rateSession.dart';

import '../../../main.dart';
import '../../../mobile/presentation/sessions/models/session.dart';
import '../../bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../core/services/call_services.dart';
import '../../core/theme/app_palette.dart';
import '../../dependency_injection/injection.dart';
import '../screen_manager/screen_manager.dart';

class CallScreen extends StatefulWidget {
  final SessionModel session;
  final int remainingMinutes;

  const CallScreen({
    super.key,
    required this.session,
    required this.remainingMinutes,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final service = CallService();

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();

  final callRef = FirebaseFirestore.instance.collection('calls');

  late String callId;
  late String currentUserId;

  Timer? _waitingTimer;
  Timer? _callTimer;

  bool _otherUserJoined = false;
  bool _remoteSet = false;
  bool _isEnding = false;

  bool mic = true;
  bool cam = true;
  bool screenSharing = false;

  Duration _remaining = Duration.zero;

  final List<RTCIceCandidate> _pending = [];

  bool get _isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  bool _desktopOpened = false;

  @override
  void initState() {
    super.initState();

    callId = widget.session.bookingCode;
    currentUserId = widget.session.userId;

    if (_isDesktop) {
      _openDesktopCall();
    } else {
      init().then((_) => _startCallTimer());
    }
  }

  // ================= DESKTOP FIX =================

  void _openDesktopCall() {
    if (_desktopOpened) return;

    _desktopOpened = true;

    Future.microtask(() async {
      final url = 'https://skill-swap-e1a3d.web.app/call.html'
          '?callId=$callId'
          '&userId=$currentUserId'
          '&minutes=${widget.remainingMinutes}';

      try {
        await Process.run(
          'cmd',
          ['/c', 'start', url],
          runInShell: true,
        );
      } catch (e) {
        debugPrint("Failed to open browser: $e");
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScreenManager(initialIndex: 3),
        ),
      );
    });
  }

  // ================= TIMER =================

  void _startCallTimer() {
    _remaining = Duration(minutes: widget.remainingMinutes);

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return timer.cancel();

      if (_remaining.inSeconds <= 1) {
        timer.cancel();

        _remaining = Duration.zero;

        if (!_isEnding) {
          _isEnding = true;

          await callRef.doc(callId).set({
            'status': 'ended',
            'endedBy': 'system',
          }, SetOptions(merge: true));
        }

        return;
      }

      setState(() {
        _remaining -= const Duration(seconds: 1);
      });
    });
  }

  // ================= INIT =================

  Future<void> init() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    await service.initLocalStream();

    localRenderer.srcObject = service.localStream;

    await service.initPeerConnection();

    service.peerConnection!.onTrack = (event) async {
      if (event.track.kind == 'video') {
        final stream = await createLocalMediaStream('remote');

        stream.addTrack(event.track);

        remoteRenderer.srcObject = stream;

        if (mounted) {
          setState(() {});
        }
      }
    };

    service.peerConnection!.onIceConnectionState = (state) async {
      debugPrint("ICE STATE => $state");

      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        try {
          final offer = await service.peerConnection!.createOffer({
            'iceRestart': true,
          });

          await service.peerConnection!.setLocalDescription(offer);

          await callRef.doc(callId).update({
            'offer': offer.toMap(),
            'renegotiate': true,
          });
        } catch (_) {}
      }
    };

    service.peerConnection!.onIceCandidate = (candidate) {
      if (candidate == null) return;

      callRef.doc(callId).collection('candidates').add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'senderId': currentUserId,
      });
    };

    await handleCallFlow();

    listenCall();
    listenCandidates();

    _startWaitingForOtherUser();
  }

  // ================= CALL FLOW =================

  Future<void> handleCallFlow() async {
    final doc = callRef.doc(callId);

    int retries = 0;

    DocumentSnapshot<Map<String, dynamic>> snap = await doc.get();

    while ((!snap.exists ||
            snap.data() == null ||
            snap.data()!['offer'] == null) &&
        retries < 10) {
      await Future.delayed(const Duration(milliseconds: 500));

      snap = await doc.get();

      retries++;
    }

    // ================= HOST =================

    if (!snap.exists || snap.data()?['offer'] == null) {
      debugPrint("I AM HOST");

      final offer = await service.peerConnection!.createOffer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });

      await service.peerConnection!.setLocalDescription(offer);

      await doc.set({
        'offer': offer.toMap(),
        'createdBy': currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return;
    }

    // ================= JOINER =================

    final data = snap.data()!;

    if (data['createdBy'] == currentUserId) {
      debugPrint("WAITING FOR ANSWER");
      return;
    }

    debugPrint("I AM JOINER");

    final offer = RTCSessionDescription(
      data['offer']['sdp'],
      data['offer']['type'],
    );

    await service.peerConnection!.setRemoteDescription(offer);

    _remoteSet = true;

    final answer = await service.peerConnection!.createAnswer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': true,
    });

    await service.peerConnection!.setLocalDescription(answer);

    await doc.set({
      'answer': answer.toMap(),
      'joinedBy': currentUserId,
    }, SetOptions(merge: true));
  }

  // ================= WAIT =================

  void _startWaitingForOtherUser() {
    _waitingTimer = Timer(const Duration(minutes: 1), () async {
      if (_otherUserJoined) return;

      await callRef.doc(callId).set({
        'status': 'ended',
        'endedBy': 'no_user_joined',
      }, SetOptions(merge: true));

      if (!mounted) return;
    });
  }

  // ================= LISTEN =================

  void listenCall() {
    callRef.doc(callId).snapshots().listen((snap) async {
      final data = snap.data();

      if (data == null) return;

      if (data['status'] == 'ended') {
        _handleCallEnded(data['endedBy']);

        return;
      }

      if (data['answer'] != null && !_remoteSet) {
        _otherUserJoined = true;

        _waitingTimer?.cancel();

        final answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        await service.peerConnection!.setRemoteDescription(answer);

        _remoteSet = true;

        for (var c in _pending) {
          await service.peerConnection!.addCandidate(c);
        }

        _pending.clear();
      }

      if (data['renegotiate'] == true && data['offer'] != null) {
        final offer = RTCSessionDescription(
          data['offer']['sdp'],
          data['offer']['type'],
        );

        await service.peerConnection!.setRemoteDescription(offer);

        final answer = await service.peerConnection!.createAnswer();

        await service.peerConnection!.setLocalDescription(answer);

        await callRef.doc(callId).update({
          'answer': answer.toMap(),
          'renegotiate': false,
        });
      }
    });
  }

  // ================= ICE =================

  void listenCandidates() {
    callRef.doc(callId).collection('candidates').snapshots().listen((snap) {
      for (var c in snap.docChanges) {
        final data = c.doc.data();

        if (data == null || data['senderId'] == currentUserId) {
          continue;
        }

        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );

        if (_remoteSet) {
          service.peerConnection!.addCandidate(candidate);
        } else {
          _pending.add(candidate);
        }
      }
    });
  }

  // ================= SCREEN SHARE =================

  Future<void> toggleScreenShare() async {
    RTCSessionDescription? offer;

    if (screenSharing) {
      offer = await service.stopScreenShare();

      screenSharing = false;
    } else {
      offer = await service.startScreenShare();

      screenSharing = true;
    }

    setState(() {});

    if (offer != null) {
      await callRef.doc(callId).update({
        'offer': offer.toMap(),
        'renegotiate': true,
      });
    }
  }

  // ================= CONTROLS =================

  void toggleMic() {
    mic = !mic;

    service.localStream?.getAudioTracks().first.enabled = mic;

    setState(() {});
  }

  void toggleCam() {
    cam = !cam;

    service.localStream?.getVideoTracks().first.enabled = cam;

    setState(() {});
  }

  void switchCamera() async {
    final track = service.localStream?.getVideoTracks().first;

    if (track != null) {
      await Helper.switchCamera(track);
    }
  }

  // ================= END =================

  void _handleCallEnded(String? endedBy) async {
    _callTimer?.cancel();

    await service.dispose();

    if (!mounted) return;

    if (_isDesktop) {
      _isEnding = true;

      _callTimer?.cancel();
      _waitingTimer?.cancel();

      await service.dispose();

      if (!mounted) return;

      desktopKey.currentState?.openSessions(tab: 0);

      Navigator.of(context).popUntil((route) => route.isFirst);

      return;
    }

    if (endedBy == 'no_user_joined') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScreenManager(
            initialIndex: 3,
            showNoUserDialog: true,
            noUserBookingCode: widget.session.bookingCode,
            noUserPrice: widget.session.price,
            isStudent: widget.session.isStudent,
          ),
        ),
      );

      return;
    }

    if (widget.session.isStudent) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<SubmitReviewBloc>(),
            child: RateSessionScreen(session: widget.session),
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScreenManager(
            initialIndex: 3,
          ),
        ),
      );
    }
  }

  // ================= DISPOSE =================
  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void dispose() {
    _callTimer?.cancel();

    _waitingTimer?.cancel();

    service.dispose();

    if (!_isDesktop) {
      localRenderer.dispose();
      remoteRenderer.dispose();
    }

    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (_isDesktop) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Opening external call...",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final isLastFiveMinutes =
        _remaining.inMinutes < 5 && _remaining.inSeconds > 0;

    final isExpired = _remaining.inSeconds == 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RTCVideoView(remoteRenderer),
          Positioned(
            top: 40,
            right: 20,
            width: 120,
            height: 160,
            child: RTCVideoView(
              localRenderer,
              mirror: true,
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isExpired
                      ? Colors.red
                      : isLastFiveMinutes
                          ? Colors.red.withOpacity(0.85)
                          : Colors.black.withOpacity(
                              0.55,
                            ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isLastFiveMinutes ? Colors.red : Colors.white24,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: isLastFiveMinutes ? Colors.white : Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isExpired
                          ? 'Start Session'
                          : _formatDuration(
                              _remaining,
                            ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: isLastFiveMinutes
                            ? FontWeight.bold
                            : FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_remaining.inSeconds <= 60 && _remaining.inSeconds > 0)
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'The session will end in one min...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _btn(
                  mic ? Icons.mic : Icons.mic_off,
                  toggleMic,
                ),
                _btn(
                  cam ? Icons.videocam : Icons.videocam_off,
                  toggleCam,
                ),
                _btn(
                  Icons.cameraswitch,
                  switchCamera,
                ),
                _btn(
                  screenSharing ? Icons.stop_screen_share : Icons.screen_share,
                  toggleScreenShare,
                  active: screenSharing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(
    IconData icon,
    VoidCallback onTap, {
    bool red = false,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: red
            ? Colors.red
            : active
                ? AppPalette.primary
                : (icon == Icons.mic_off || icon == Icons.videocam_off
                    ? Colors.grey
                    : Colors.white24),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
