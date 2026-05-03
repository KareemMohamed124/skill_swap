import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../core/services/call_services_desktop.dart';

class DesktopCallScreen extends StatefulWidget {
  final SessionModel session;

  const DesktopCallScreen({
    super.key,
    required this.session,
  });

  @override
  State<DesktopCallScreen> createState() => _DesktopCallScreenState();
}

class _DesktopCallScreenState extends State<DesktopCallScreen> {
  final service = DesktopCallService();

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  late String callId;
  late String userId;
  final callRef = FirebaseFirestore.instance.collection('calls');

  bool _remoteSet = false;
  final List<RTCIceCandidate> _pending = [];

  @override
  void initState() {
    super.initState();
    callId = widget.session.bookingCode;
    userId = widget.session.userId;
    init();
  }

  Future<void> init() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    await service.initLocalStream();

    if (service.localStream == null) {
      debugPrint("❌ camera denied");
      return;
    }

    localRenderer.srcObject = service.localStream;

    await service.initPeerConnection();

    // ✅ FIX (no crash)
    service.peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams.first;
        setState(() {});
      }
    };

    service.peerConnection!.onIceCandidate = (c) {
      if (c == null) return;

      callRef.doc(callId).collection('candidates').add({
        'candidate': c.candidate,
        'sdpMid': c.sdpMid,
        'sdpMLineIndex': c.sdpMLineIndex,
        'senderId': userId,
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
    });
  }

  // ================= ICE =================
  void listenCandidates() {
    callRef.doc(callId).collection('candidates').snapshots().listen((snap) {
      for (var change in snap.docChanges) {
        final data = change.doc.data();
        if (data == null || data['senderId'] == userId) continue;

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

  // ================= END =================
  void endCall() async {
    await callRef.doc(callId).delete();
    await service.dispose();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
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
            top: 20,
            right: 20,
            width: 150,
            height: 200,
            child: RTCVideoView(localRenderer, mirror: true),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.call_end, color: Colors.red, size: 40),
                onPressed: endCall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
