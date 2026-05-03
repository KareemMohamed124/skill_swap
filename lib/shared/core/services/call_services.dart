import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? screenStream;

  bool isScreenSharing = false;

  static const _channel = MethodChannel('skill_swap/screen_capture');

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  // ================= LOCAL =================
  Future<void> initLocalStream() async {
    localStream = await navigator.mediaDevices.getUserMedia({
      'video': {'facingMode': 'user'},
      'audio': true,
    });
  }

  // ================= PEER =================
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
    });

    for (var track in localStream!.getTracks()) {
      await peerConnection!.addTrack(track, localStream!);
    }
  }

  // ================= REPLACE TRACK =================
  Future<RTCSessionDescription?> replaceVideoTrack(
      MediaStreamTrack newTrack) async {
    final senders = await peerConnection!.getSenders();

    for (var sender in senders) {
      if (sender.track?.kind == 'video') {
        await sender.replaceTrack(newTrack);

        final offer = await peerConnection!.createOffer();
        await peerConnection!.setLocalDescription(offer);

        return offer;
      }
    }
    return null;
  }

  // ================= SCREEN SHARE =================
  Future<RTCSessionDescription?> startScreenShare() async {
    try {
      // ✅ Android فقط - Desktop مش محتاجها
      if (_isAndroid) {
        await _channel.invokeMethod('startScreenCaptureService');
      }

      screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': false,
      });

      if (screenStream == null) return null;

      isScreenSharing = true;

      screenStream!.getVideoTracks().first.onEnded = () {
        stopScreenShare();
      };

      return await replaceVideoTrack(
        screenStream!.getVideoTracks().first,
      );
    } catch (e) {
      debugPrint("❌ Screen share error: $e");
      isScreenSharing = false;
      return null;
    }
  }

  Future<RTCSessionDescription?> stopScreenShare() async {
    if (!isScreenSharing) return null;

    final cameraTrack = localStream?.getVideoTracks().first;
    RTCSessionDescription? offer;

    if (cameraTrack != null) {
      offer = await replaceVideoTrack(cameraTrack);
    }

    await screenStream?.dispose();
    screenStream = null;
    isScreenSharing = false;

    // ✅ Android فقط
    if (_isAndroid) {
      await _channel.invokeMethod('stopScreenCaptureService');
    }

    return offer;
  }

  Future<void> dispose() async {
    await localStream?.dispose();
    await screenStream?.dispose();
    await peerConnection?.close();
    peerConnection = null;
  }
}
