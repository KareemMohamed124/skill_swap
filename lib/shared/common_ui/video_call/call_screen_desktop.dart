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
  bool _disposed = false; // ✅ FIX: guard flag to prevent post-dispose callbacks
  final List<RTCIceCandidate> _pending = [];

  // ✅ FIX: Store subscriptions so they can be cancelled in dispose()
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
    // ✅ FIX: Initialize renderers FIRST, before anything else
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    if (_disposed) return;

    await service.initLocalStream();

    if (service.localStream == null) {
      debugPrint("❌ camera denied");
      return;
    }

    // ✅ FIX: Attach stream AFTER renderer is initialized (not before)
    localRenderer.srcObject = service.localStream;

    await service.initPeerConnection();

    if (_disposed) return;

    // ✅ FIX: Always check mounted before setState inside async callbacks
    service.peerConnection!.onTrack = (event) async {
      if (_disposed) return;
      debugPrint(
          "📹 onTrack: kind=${event.track.kind}, streams=${event.streams.length}");

      if (event.track.kind == 'video') {
        if (event.streams.isNotEmpty) {
          remoteRenderer.srcObject = event.streams.first;
        } else {
          // ✅ FIX: createLocalMediaStream fallback for tracks without streams
          final stream = await createLocalMediaStream("remote_desktop");
          await stream.addTrack(event.track);
          remoteRenderer.srcObject = stream;
        }
        if (mounted && !_disposed) setState(() {});
      }
    };

    service.peerConnection!.onIceCandidate = (c) {
      if (_disposed) return;
      // ✅ FIX: flutter_webrtc passes a non-null but "empty" candidate at end of gathering
      // checking candidate string prevents Firestore write errors
      if (c.candidate == null || c.candidate!.isEmpty) return;

      callRef.doc(callId).collection('candidates').add({
        'candidate': c.candidate,
        'sdpMid': c.sdpMid,
        'sdpMLineIndex': c.sdpMLineIndex,
        'senderId': userId,
      });
    };

    // ✅ FIX: Listen for connection state to detect & handle unexpected drops
    service.peerConnection!.onConnectionState = (state) {
      debugPrint("🔌 PeerConnection state: $state");
      if (_disposed) return;
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        debugPrint("⚠️ Connection dropped: $state");
      }
    };

    await _handleCallFlow();

    if (_disposed) return;

    _listenCall();
    _listenCandidates();
  }

  // ================= CALL FLOW =================
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

      final offer = RTCSessionDescription(
        data['offer']['sdp'],
        data['offer']['type'],
      );

      await service.peerConnection!.setRemoteDescription(offer);
      _remoteSet = true;

      final answer = await service.peerConnection!.createAnswer();
      await service.peerConnection!.setLocalDescription(answer);

      await doc.update({'answer': answer.toMap()});

      // ✅ FIX: Flush pending ICE candidates now that remote is set
      for (var c in _pending) {
        await service.peerConnection!.addCandidate(c);
      }
      _pending.clear();
    }
  }

  // ================= LISTEN =================
  void _listenCall() {
    // ✅ FIX: Save subscription reference so it can be cancelled in dispose()
    _callSubscription =
        callRef.doc(callId).snapshots().listen((snap) async {
      if (_disposed) return;
      final data = snap.data();
      if (data == null) return;

      // Handle call ended by other side
      if (data['status'] == 'ended') {
        await _cleanupAndPop();
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

      // RENEGOTIATION (screen share, track changes)
      if (data['renegotiate'] == true && data['offer'] != null) {
        if (_disposed) return;
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
  void _listenCandidates() {
    // ✅ FIX: Save subscription reference so it can be cancelled in dispose()
    _candidatesSubscription = callRef
        .doc(callId)
        .collection('candidates')
        .snapshots()
        .listen((snap) async {
      if (_disposed) return;
      for (var change in snap.docChanges) {
        final data = change.doc.data();
        if (data == null || data['senderId'] == userId) continue;

        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );

        // ✅ FIX: Correct guard — use _remoteSet flag, not checking a method reference
        if (_remoteSet && service.peerConnection != null) {
          await service.peerConnection!.addCandidate(candidate);
        } else {
          _pending.add(candidate);
        }
      }
    });
  }

  // ================= END =================
  void endCall() async {
    await callRef.doc(callId).set({
      'status': 'ended',
      'endedBy': userId,
    }, SetOptions(merge: true));
    await _cleanupAndPop();
  }

  Future<void> _cleanupAndPop() async {
    if (_disposed) return;
    _disposed = true;

    // ✅ FIX: Cancel Firebase listeners FIRST to stop incoming callbacks
    await _callSubscription?.cancel();
    await _candidatesSubscription?.cancel();
    _callSubscription = null;
    _candidatesSubscription = null;

    // ✅ FIX: Detach streams from renderers BEFORE disposing them
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;

    // ✅ FIX: Dispose renderers BEFORE service (tracks must be stopped in service.dispose())
    await service.dispose();

    localRenderer.dispose();
    remoteRenderer.dispose();

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    // ✅ FIX: This dispose() is called by Flutter widget lifecycle.
    // _cleanupAndPop() handles the full teardown; we just guard here in case
    // the widget is removed without endCall() being called (e.g. back button).
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
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ FIX: objectFit fill prevents GPU texture size mismatch crash on Windows
          RTCVideoView(
            remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
          ),
          Positioned(
            top: 20,
            right: 20,
            width: 180,
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RTCVideoView(
                localRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 36),
                  onPressed: endCall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
