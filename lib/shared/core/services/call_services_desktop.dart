import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DesktopCallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  Future<void> initLocalStream() async {
    try {
      // ✅ Fix: Disable all hardware audio processing which causes native crashes on some Windows drivers
      localStream = await navigator.mediaDevices.getUserMedia({
        'audio': {
          'echoCancellation': false,
          'noiseSuppression': false,
          'autoGainControl': false,
        },
        'video': {
          'width': 640,
          'height': 480,
          'frameRate': 30,
        },
      });
    } catch (e) {
      debugPrint("❌ getUserMedia error: $e");
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
        {
          "urls": "turn:openrelay.metered.ca:80",
          "username": "openrelayproject",
          "credential": "openrelayproject",
        },
      ],
      "sdpSemantics": "unified-plan",
      "iceCandidatePoolSize": 10,
    });

    if (localStream != null) {
      for (var track in localStream!.getTracks()) {
        await peerConnection!.addTrack(track, localStream!);
      }
    }
  }

  Future<void> dispose() async {
    try {
      if (localStream != null) {
        for (var track in localStream!.getTracks()) {
          track.stop();
        }
        await localStream?.dispose();
        localStream = null;
      }

      if (peerConnection != null) {
        peerConnection!.onIceCandidate = null;
        peerConnection!.onTrack = null;
        
        await peerConnection?.close();
        await peerConnection?.dispose();
        peerConnection = null;
      }
    } catch (e) {
      debugPrint("❌ Dispose error: $e");
    }
  }
}
