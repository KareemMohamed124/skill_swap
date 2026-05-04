import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:skill_swap/shared/common_ui/video_call/rateSession.dart';

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../core/services/call_services.dart';
import '../../core/theme/app_palette.dart';
import '../../dependency_injection/injection.dart';
import '../screen_manager/screen_manager.dart';

class CallScreen extends StatefulWidget {
  final SessionModel session;

  const CallScreen({super.key, required this.session});

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

  bool mic = true;
  bool cam = true;
  bool screenSharing = false;

  bool _remoteSet = false;
  bool _isEnding = false;

  final List<RTCIceCandidate> _pending = [];

  // ================= TIMER =================
  Timer? _callTimer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    callId = widget.session.bookingCode;
    currentUserId = widget.session.userId;
    init().then((_) => _startCallTimer());
  }

  // ================= TIMER LOGIC =================
  void _startCallTimer() {
    final sessionEnd = widget.session.dateTime.add(
      Duration(minutes: widget.session.duration.toInt()),
    );
    final now = DateTime.now();
    _remaining = sessionEnd.difference(now);
    if (_remaining.isNegative || _remaining.inSeconds < 60) {
      _remaining = const Duration(minutes: 1);
    }
    _remaining = const Duration(hours: 1);

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remaining.inSeconds <= 1) {
          _remaining = Duration.zero;
          timer.cancel();
          _autoEndCall();
        } else {
          _remaining = _remaining - const Duration(seconds: 1);
        }
      });
    });
  }

  Future<void> _autoEndCall() async {
    if (_isEnding) return;
    _isEnding = true;

    await callRef.doc(callId).set({
      'status': 'ended',
      'endedBy': 'system',
    }, SetOptions(merge: true));
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  // ================= INIT =================
  Future<void> init() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    await service.initLocalStream();
    localRenderer.srcObject = service.localStream;

    await service.initPeerConnection();

    service.peerConnection!.onTrack = (event) async {
      print("TRACK: ${event.track.kind}");

      if (event.track.kind == 'video') {
        final stream = await createLocalMediaStream("remote");
        stream.addTrack(event.track);

        remoteRenderer.srcObject = stream;
        setState(() {});
      }
    };

    service.peerConnection!.onIceCandidate = (c) {
      if (c == null) return;

      callRef.doc(callId).collection('candidates').add({
        'candidate': c.candidate,
        'sdpMid': c.sdpMid,
        'sdpMLineIndex': c.sdpMLineIndex,
        'senderId': currentUserId,
      });
    };

    await handleCallFlow();

    listenCall();
    listenCandidates();
  }

  // ================= CALL FLOW =================
  Future<void> handleCallFlow() async {
    final doc = callRef.doc(callId);
    final snap = await doc.get();

    if (!snap.exists) {
      final offer = await service.peerConnection!.createOffer();
      await service.peerConnection!.setLocalDescription(offer);

      await doc.set({'offer': offer.toMap()});
    } else {
      final data = snap.data()!;

      final offer = RTCSessionDescription(
        data['offer']['sdp'],
        data['offer']['type'],
      );

      await service.peerConnection!.setRemoteDescription(offer);
      _remoteSet = true;

      final answer = await service.peerConnection!.createAnswer();
      await service.peerConnection!.setLocalDescription(answer);

      await doc.update({'answer': answer.toMap()});
    }
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

  void _handleCallEnded(String? endedBy) async {
    _callTimer?.cancel();
    await service.dispose();

    if (!mounted) return;

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

  // ================= ICE =================
  void listenCandidates() {
    callRef.doc(callId).collection('candidates').snapshots().listen((snap) {
      for (var c in snap.docChanges) {
        final data = c.doc.data();
        if (data == null || data['senderId'] == currentUserId) continue;

        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );

        if (service.peerConnection!.setRemoteDescription != null) {
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

  // ================= DISPOSE =================
  @override
  void dispose() {
    _callTimer?.cancel();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final isLastFiveMinutes =
        _remaining.inMinutes < 5 && _remaining.inSeconds > 0;
    final isExpired = _remaining.inSeconds == 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Remote Video ──
          RTCVideoView(remoteRenderer),

          // ── Local Video ──
          Positioned(
            top: 40,
            right: 20,
            width: 120,
            height: 160,
            child: RTCVideoView(localRenderer, mirror: true),
          ),

          // ── Timer Badge ──
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isExpired
                      ? Colors.red
                      : isLastFiveMinutes
                          ? Colors.red.withOpacity(0.85)
                          : Colors.black.withOpacity(0.55),
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
                      isExpired ? 'انتهت الجلسة' : _formatDuration(_remaining),
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

          // ── تحذير آخر دقيقة ──
          if (_remaining.inSeconds <= 60 && _remaining.inSeconds > 0)
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⚠️ الجلسة ستنتهي خلال دقيقة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // ── Control Buttons (بدون زرار إنهاء) ──
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _btn(mic ? Icons.mic : Icons.mic_off, toggleMic),
                _btn(cam ? Icons.videocam : Icons.videocam_off, toggleCam),
                _btn(Icons.cameraswitch, switchCamera),
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

  Widget _btn(IconData icon, VoidCallback onTap,
      {bool red = false, bool active = false}) {
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
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
