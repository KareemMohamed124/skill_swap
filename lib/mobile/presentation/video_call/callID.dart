import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'LiveKeys.dart';

class CallPage extends StatefulWidget {
  final String callID;
  final String userID;
  final String userName;

  const CallPage({
    Key? key,
    required this.callID,
    required this.userID,
    required this.userName,
  }) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      //Permission.notification,
      Permission.bluetoothConnect,
    ].request();
  }

  bool isFullscreen = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: LiveKeys.appId /*input your AppID*/,
        appSign: LiveKeys.appSign /*input your AppSign*/,
        userID: widget.userID,
        userName: widget.userName,
        callID: widget.callID,
        config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          // ..turnOnScreenSharingWhenJoining = false // اختياري
          ..bottomMenuBarConfig.buttons = [
            ZegoCallMenuBarButtonName.toggleMicrophoneButton,
            ZegoCallMenuBarButtonName.toggleCameraButton,
            ZegoCallMenuBarButtonName.switchCameraButton,
            ZegoCallMenuBarButtonName.hangUpButton,
            ZegoCallMenuBarButtonName.toggleScreenSharingButton,
          ]
          ..audioVideoViewConfig.foregroundBuilder =
              (context, size, user, extraInfo) {
            return OutlinedButton(
              onPressed: () {
                isFullscreen = !isFullscreen;
                ZegoUIKitPrebuiltCallController()
                    .screenSharing
                    .showViewInFullscreenMode(
                      user?.id ?? '',
                      isFullscreen,
                    );
              },
              child: const Text('full screen'),
            );
          },
      ),
    );
  }
}
