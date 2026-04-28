import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' hide navigator;

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../../mobile/presentation/video_call/rateSession.dart';
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
  bool _isRemoteDescriptionSet = false;
  bool screenSharing = false;

  final callRef = FirebaseFirestore.instance.collection('calls');

  late final String callId;
  late final String currentUserId;

  bool mic = true;
  bool cam = true;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    callId = widget.session.bookingCode;
    currentUserId = widget.session.userId;
    init();
  }

  Future<void> init() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    await service.initLocalStream();
    localRenderer.srcObject = service.localStream;
    setState(() {});

    await service.initPeerConnection();

    service.peerConnection!.onTrack = (event) {
      print("✅ TRACK RECEIVED: ${event.track.kind}");
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
        setState(() {});
      }
    };

    service.peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        callRef.doc(callId).collection('candidates').add({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
          'senderId': currentUserId,
        });
      }
    };

    await handleCallFlow();

    listenForAnswer();
    listenForCandidates();
    listenForEndCall();
  }

  // ================= CALL FLOW =================
  Future<void> handleCallFlow() async {
    final doc = callRef.doc(callId);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      /// FIRST USER
      final offer = await service.peerConnection!.createOffer();
      await service.peerConnection!.setLocalDescription(offer);

      await doc.set({
        'offer': offer.toMap(),
        'status': 'ringing',
      });
    } else {
      final data = snapshot.data()!;

      /// SECOND USER
      final offer = RTCSessionDescription(
        data['offer']['sdp'],
        data['offer']['type'],
      );

      await service.peerConnection!.setRemoteDescription(offer);

      final answer = await service.peerConnection!.createAnswer();
      await service.peerConnection!.setLocalDescription(answer);

      await doc.update({
        'answer': answer.toMap(),
        'status': 'connected',
      });
    }
  }

  // ================= ANSWER =================
  void listenForAnswer() {
    callRef.doc(callId).snapshots().listen((snapshot) async {
      final data = snapshot.data();

      if (data?['answer'] != null && !_isRemoteDescriptionSet) {
        final answer = RTCSessionDescription(
          data!['answer']['sdp'],
          data['answer']['type'],
        );

        await service.peerConnection!.setRemoteDescription(answer);

        _isRemoteDescriptionSet = true;
      }
    });
  }

  // ================= ICE =================
  void listenForCandidates() {
    callRef.doc(callId).collection('candidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        final data = change.doc.data();

        if (data != null && data['senderId'] != currentUserId) {
          service.peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              (data['sdpMLineIndex'] as num).toInt(),
            ),
          );
        }
      }
    });
  }

  // ================= END =================
  void listenForEndCall() {
    callRef.doc(callId).snapshots().listen((snapshot) {
      final data = snapshot.data();

      if (data?['status'] == 'ended') {
        final endedBy = data?['endedBy'];
        _handleCallEnded(endedBy);
      }
    });
  }

  Future<void> _handleCallEnded(String? endedBy) async {
    if (_navigated) return;
    _navigated = true;

    await service.dispose();

    if (!mounted) return;

    // if (endedBy == currentUserId) {
    //   Get.back();
    //   return;
    // }

    if (widget.session.isStudent) {
      Get.to(
        () => BlocProvider(
          create: (_) => sl<SubmitReviewBloc>(),
          child: RateSessionScreen(session: widget.session),
        ),
      );
    } else {
      Get.to(() => ScreenManager(
            initialIndex: 3,
            initialSessionTab: 0,
          ));
    }
  }

  void endCall() async {
    await callRef.doc(callId).set({
      'status': 'ended',
      'endedBy': currentUserId,
    }, SetOptions(merge: true));

    await service.dispose();
  }

  // ================= CONTROLS =================
  void toggleMic() {
    mic = !mic;
    service.localStream?.getAudioTracks().first.enabled = mic;
    setState(() {});
  }

  void toggleScreenShare() async {
    if (screenSharing) {
      await service.stopScreenShare();
      setState(() => screenSharing = false);
      return;
    }

    // استخدم defaultTargetPlatform بدل Platform.isWindows
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      final sources = await service.getScreenSources();
      if (sources.isEmpty) return;

      final selected = await showDialog<DesktopCapturerSource>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Choose Screen',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 500,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: sources.length,
              itemBuilder: (ctx, i) {
                final source = sources[i];
                return GestureDetector(
                  onTap: () => Navigator.pop(ctx, source),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (source.thumbnail != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Image.memory(
                                source.thumbnail!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            source.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      if (selected == null) return;
      await service.startScreenShareWithSource(selected);
    } else {
      await service.startScreenShare();
    }

    setState(() => screenSharing = service.isScreenSharing);
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final isConnected = remoteRenderer.srcObject != null;

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
            child: RTCVideoView(localRenderer, mirror: true),
          ),
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
                _btn(Icons.call_end, endCall, red: true),
              ],
            ),
          ),
          if (!isConnected) _waitingUI(),
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

  Widget _waitingUI() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Connecting...", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
