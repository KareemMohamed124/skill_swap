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

  Future<void> initLocalStream() async {
    localStream = await navigator.mediaDevices.getUserMedia({
      'video': {'facingMode': 'user'},
      'audio': true,
    });
  }

  Map<String, dynamic> _iceConfig() {
    return {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"},
        {"urls": "stun:stun1.l.google.com:19302"},
        {"urls": "stun:stun.cloudflare.com:3478"},
        {
          "urls": "turn:openrelay.metered.ca:80",
          "username": "openrelayproject",
          "credential": "openrelayproject",
        },
      ],
      "sdpSemantics": "unified-plan",
      "iceCandidatePoolSize": 10,
    };
  }

  Future<void> initPeerConnection() async {
    peerConnection = await createPeerConnection(_iceConfig());

    for (var track in localStream?.getTracks() ?? []) {
      await peerConnection!.addTrack(track, localStream!);
    }

    peerConnection!.onRenegotiationNeeded = () async {
      try {
        debugPrint("renegotiation triggered");

        final offer = await peerConnection!.createOffer();
        await peerConnection!.setLocalDescription(offer);

        // IMPORTANT: send this via Firestore signaling
      } catch (e) {
        debugPrint("Renegotiation error: $e");
      }
    };

    peerConnection!.onIceConnectionState = (state) {
      debugPrint("ICE STATE => $state");
    };

    peerConnection!.onConnectionState = (state) {
      debugPrint("CONNECTION STATE => $state");
    };

    peerConnection!.onIceGatheringState = (state) {
      debugPrint("ICE GATHERING => $state");
    };
  }

  Future<RTCSessionDescription?> replaceVideoTrack(
      MediaStreamTrack newTrack) async {
    final senders = await peerConnection!.getSenders();

    for (var sender in senders) {
      if (sender.track?.kind == 'video') {
        await sender.replaceTrack(newTrack);

        await Future.delayed(const Duration(milliseconds: 250));

        final offer = await peerConnection!.createOffer({
          "iceRestart": true,
        });

        await peerConnection!.setLocalDescription(offer);

        return offer;
      }
    }
    return null;
  }

  Future<RTCSessionDescription?> startScreenShare() async {
    try {
      if (_isAndroid) {
        await _channel.invokeMethod('startScreenCaptureService');
      }

      screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': false,
      });

      isScreenSharing = true;

      screenStream!.getVideoTracks().first.onEnded = () async {
        await stopScreenShare();
      };

      return await replaceVideoTrack(
        screenStream!.getVideoTracks().first,
      );
    } catch (e) {
      debugPrint("Screen share error: $e");
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

    for (var t in screenStream?.getTracks() ?? []) {
      t.stop();
    }

    await screenStream?.dispose();
    screenStream = null;

    isScreenSharing = false;

    if (_isAndroid) {
      await _channel.invokeMethod('stopScreenCaptureService');
    }

    return offer;
  }

  Future<void> dispose() async {
    try {
      for (var t in localStream?.getTracks() ?? []) {
        t.stop();
      }

      for (var t in screenStream?.getTracks() ?? []) {
        t.stop();
      }

      await localStream?.dispose();
      await screenStream?.dispose();

      await peerConnection?.close();
      peerConnection = null;
    } catch (_) {}
  }
}
