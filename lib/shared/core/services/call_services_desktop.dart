import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DesktopCallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  // ✅ FIX: Richer constraints for Windows — avoids native crash from default constraints
  Future<void> initLocalStream() async {
    try {
      localStream = await navigator.mediaDevices.getUserMedia({
        'video': {
          'mandatory': {
            'minWidth': '640',
            'minHeight': '480',
            'minFrameRate': '15',
          },
          'optional': [],
        },
        'audio': true,
      });
    } catch (e) {
      debugPrint("❌ getUserMedia error: $e");
      localStream = null;
    }
  }

  Future<void> initPeerConnection() async {
    peerConnection = await createPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"},
        {"urls": "stun:stun1.l.google.com:19302"},
        {
          "urls": "turn:openrelay.metered.ca:80",
          "username": "openrelayproject",
          "credential": "openrelayproject",
        },
      ],
      // ✅ CRITICAL: unified-plan is required on desktop — plan-b causes crashes
      "sdpSemantics": "unified-plan",
    });

    // ✅ FIX: use addTrack (not addStream which is deprecated and crashes on desktop)
    if (localStream != null) {
      for (var track in localStream!.getTracks()) {
        await peerConnection!.addTrack(track, localStream!);
      }
    }
  }

  Future<void> dispose() async {
    // ✅ FIX: Stop all tracks FIRST before disposing stream/connection
    // Skipping this causes a native access violation on Windows ~3s after call ends
    localStream?.getTracks().forEach((track) {
      track.stop();
    });

    await localStream?.dispose();
    localStream = null;

    await peerConnection?.close();
    // ✅ FIX: Must call dispose() on the peer connection, not just close()
    peerConnection?.dispose();
    peerConnection = null;
  }
}
