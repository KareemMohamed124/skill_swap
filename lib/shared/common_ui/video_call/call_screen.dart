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

  final List<RTCIceCandidate> _pending = [];

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

    await service.initPeerConnection();

    // ✅ FIX onTrack
// ================= TRACK FIX =================
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

      // ANSWER
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

      // 🔥 RENEGOTIATION
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
    await service.dispose();

    if (!mounted) return;

    // 👇 هنا التحكم في navigation
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

  void endCall() async {
    await callRef.doc(callId).set({
      'status': 'ended',
      'endedBy': currentUserId,
    }, SetOptions(merge: true));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
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
