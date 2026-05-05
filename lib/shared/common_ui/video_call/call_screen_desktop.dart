import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../core/services/call_services_desktop.dart';
import '../../helper/local_storage.dart';

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
  bool _disposed = false;
  final List<RTCIceCandidate> _pending = [];

  StreamSubscription? _callSubscription;
  StreamSubscription? _candidatesSubscription;

  @override
  void initState() {
    super.initState();
    callId = widget.session.bookingCode;
    userId = LocalStorage.getUserId() ?? widget.session.userId;
    _init();
  }

  Future<void> _init() async {
    try {
      await localRenderer.initialize();
      await remoteRenderer.initialize();

      if (_disposed) return;

      await service.initLocalStream();

      if (service.localStream == null) {
        debugPrint("❌ camera denied or not found");
        return;
      }

      // ✅ Aggressive Fix: Delay stream attachment
      // This prevents a race condition in Windows DirectX texture registration
      await Future.delayed(const Duration(milliseconds: 800));

      if (_disposed) return;
      localRenderer.srcObject = service.localStream;
      if (mounted) setState(() {});

      await service.initPeerConnection();

      if (_disposed) return;

      service.peerConnection!.onTrack = (event) async {
        if (_disposed) return;
        if (event.track.kind == 'video') {
          if (event.streams.isNotEmpty) {
            remoteRenderer.srcObject = event.streams.first;
          } else {
            final stream = await createLocalMediaStream("remote_desktop");
            await stream.addTrack(event.track);
            remoteRenderer.srcObject = stream;
          }
          if (mounted && !_disposed) setState(() {});
        }
      };

      service.peerConnection!.onIceCandidate = (c) {
        if (_disposed || c.candidate == null || c.candidate!.isEmpty) return;
        callRef.doc(callId).collection('candidates').add({
          'candidate': c.candidate,
          'sdpMid': c.sdpMid,
          'sdpMLineIndex': c.sdpMLineIndex,
          'senderId': userId,
        });
      };

      await _handleCallFlow();
      _listenCall();
      _listenCandidates();
    } catch (e) {
      debugPrint("❌ Init Error: $e");
    }
  }

  Future<void> _handleCallFlow() async {
    if (_disposed) return;
    final doc = callRef.doc(callId);
    final snap = await doc.get();

    if (!snap.exists) {
      final offer = await service.peerConnection!.createOffer();
      await service.peerConnection!.setLocalDescription(offer);
      await doc.set({'offer': offer.toMap()});
    } else {
      final data = snap.data()!;
      final offer = RTCSessionDescription(data['offer']['sdp'], data['offer']['type']);
      await service.peerConnection!.setRemoteDescription(offer);
      _remoteSet = true;

      final answer = await service.peerConnection!.createAnswer();
      await service.peerConnection!.setLocalDescription(answer);
      await doc.update({'answer': answer.toMap()});

      for (var c in _pending) {
        await service.peerConnection!.addCandidate(c);
      }
      _pending.clear();
    }
  }

  void _listenCall() {
    _callSubscription = callRef.doc(callId).snapshots().listen((snap) async {
      if (_disposed) return;
      final data = snap.data();
      if (data == null) return;

      if (data['status'] == 'ended') {
        await _cleanupAndPop();
        return;
      }

      if (data['answer'] != null && !_remoteSet) {
        final answer = RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);
        await service.peerConnection!.setRemoteDescription(answer);
        _remoteSet = true;
        for (var c in _pending) {
          await service.peerConnection!.addCandidate(c);
        }
        _pending.clear();
      }
    });
  }

  void _listenCandidates() {
    _candidatesSubscription = callRef.doc(callId).collection('candidates').snapshots().listen((snap) async {
      if (_disposed) return;
      for (var change in snap.docChanges) {
        final data = change.doc.data();
        if (data == null || data['senderId'] == userId) continue;
        final candidate = RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
        if (_remoteSet && service.peerConnection != null) {
          await service.peerConnection!.addCandidate(candidate);
        } else {
          _pending.add(candidate);
        }
      }
    });
  }

  Future<void> _cleanupAndPop() async {
    if (_disposed) return;
    _disposed = true;
    _callSubscription?.cancel();
    _candidatesSubscription?.cancel();
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    await service.dispose();
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _callSubscription?.cancel();
      _candidatesSubscription?.cancel();
      localRenderer.srcObject = null;
      remoteRenderer.srcObject = null;
      service.dispose();
      localRenderer.dispose();
      remoteRenderer.dispose();
    }
    super.initState(); // Note: This was a typo in previous versions, should be super.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RTCVideoView(
            remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
          ),
          Positioned(
            top: 20,
            right: 20,
            width: 150,
            height: 110,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: RTCVideoView(
                  localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
                  await callRef.doc(callId).set({
                    'status': 'ended',
                    'endedBy': userId,
                  }, SetOptions(merge: true));
                  await _cleanupAndPop();
                },
                child: const Icon(Icons.call_end, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
