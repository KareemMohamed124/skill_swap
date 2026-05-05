import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DesktopCallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  Future<void> initLocalStream() async {
    try {
      // ✅ Aggressive Fix: Simplified constraints for Windows stability
      // Some Windows cameras crash when 'mandatory' is too strict.
      localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'width': 640,
          'height': 480,
          'frameRate': 30,
        },
      });
    } catch (e) {
      debugPrint("❌ getUserMedia error: $e");
      // Fallback to even simpler constraints if the above fails
      try {
        localStream = await navigator.mediaDevices.getUserMedia({
          'audio': true,
          'video': true,
        });
      } catch (e2) {
        localStream = null;
      }
    }
  }

  Future<void> initPeerConnection() async {
    peerConnection = await createPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"},
        {"urls": "stun:stun1.l.google.com:19302"},
      ],
      "sdpSemantics": "unified-plan",
    });

    if (localStream != null) {
      for (var track in localStream!.getTracks()) {
        await peerConnection!.addTrack(track, localStream!);
      }
    }
  }

  Future<void> dispose() async {
    if (localStream != null) {
      for (var track in localStream!.getTracks()) {
        track.stop();
      }
      await localStream?.dispose();
      localStream = null;
    }

    if (peerConnection != null) {
      await peerConnection?.close();
      await peerConnection?.dispose();
      peerConnection = null;
    }
  }
}
