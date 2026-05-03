import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DesktopCallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  Future<void> initLocalStream() async {
    try {
      localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
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
        {
          "urls": "turn:openrelay.metered.ca:80",
          "username": "openrelayproject",
          "credential": "openrelayproject",
        },
      ],
      "sdpSemantics": "unified-plan",
    });

    for (var track in localStream!.getTracks()) {
      await peerConnection!.addTrack(track, localStream!);
    }
  }

  Future<void> dispose() async {
    await localStream?.dispose();
    await peerConnection?.close();
    peerConnection = null;
  }
}
