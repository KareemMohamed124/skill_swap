import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? screenStream;
  bool isScreenSharing = false;

  // ================= HELPER =================
  bool get _isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> initLocalStream() async {
    if (_isWindows) {
      localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
        'audio': true,
      });
    } else {
      localStream = await navigator.mediaDevices.getUserMedia({
        'video': {'facingMode': 'user'},
        'audio': true,
      });
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
        {
          "urls": "turn:openrelay.metered.ca:443",
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

  // ================= SCREEN SHARE =================
  Future<void> startScreenShare() async {
    try {
      if (_isAndroid) {
        screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': true,
          'audio': false,
        });
      }
      // Windows يتعامل معاه من الـ UI عن طريق startScreenShareWithSource

      if (screenStream == null) return;
      await _replaceVideoTrack(screenStream!.getVideoTracks().first);
      isScreenSharing = true;

      screenStream!.getVideoTracks().first.onEnded = () {
        stopScreenShare();
      };
    } catch (e) {
      print('❌ Screen share error: $e');
      isScreenSharing = false;
    }
  }

  Future<List<DesktopCapturerSource>> getScreenSources() async {
    if (_isWindows) {
      return await desktopCapturer.getSources(
        types: [SourceType.Screen, SourceType.Window],
      );
    }
    return [];
  }

  Future<void> startScreenShareWithSource(DesktopCapturerSource source) async {
    try {
      screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': {
          'deviceId': {'exact': source.id},
          'mandatory': {
            'minWidth': 1280,
            'minHeight': 720,
            'minFrameRate': 15,
          }
        },
        'audio': false,
      });

      if (screenStream == null) return;
      await _replaceVideoTrack(screenStream!.getVideoTracks().first);
      isScreenSharing = true;

      screenStream!.getVideoTracks().first.onEnded = () {
        stopScreenShare();
      };
    } catch (e) {
      print('❌ Screen share with source error: $e');
    }
  }

  // ================= HELPER - Replace Track =================
  Future<void> _replaceVideoTrack(MediaStreamTrack newTrack) async {
    final senders = await peerConnection!.getSenders();
    for (var sender in senders) {
      if (sender.track?.kind == 'video') {
        await sender.replaceTrack(newTrack);
        break;
      }
    }
  }

  Future<void> stopScreenShare() async {
    if (!isScreenSharing) return;

    final cameraTrack = localStream?.getVideoTracks().first;
    if (cameraTrack != null) {
      await _replaceVideoTrack(cameraTrack);
    }

    await screenStream?.dispose();
    screenStream = null;
    isScreenSharing = false;
  }

  Future<void> dispose() async {
    await screenStream?.dispose();
    await localStream?.dispose();
    await peerConnection?.close();
    peerConnection = null;
    localStream = null;
    screenStream = null;
  }
}
