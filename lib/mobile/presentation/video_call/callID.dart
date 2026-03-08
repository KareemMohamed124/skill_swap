import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill_swap/mobile/presentation/video_call/rateSession.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../shared/helper/local_storage.dart';
import '../sessions/models/session.dart';
import 'LiveKeys.dart';

class CallPage extends StatefulWidget {
  final SessionModel session;

  const CallPage({Key? key, required this.session}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool isFullscreen = true;
  String? currentUserId;
  final Map<String, String> userAvatars = {};

  @override
  void initState() {
    super.initState();
    requestPermissions();
    getCurrentUser();

    if (widget.session.image != null) {
      userAvatars[widget.session.instructorId] = widget.session.image!;
    }
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.bluetoothConnect,
    ].request();
  }

  Future<void> getCurrentUser() async {
    currentUserId = await LocalStorage.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ZegoUIKitPrebuiltCall(
            appID: LiveKeys.appId,
            appSign: LiveKeys.appSign,
            userID: widget.session.instructorId,
            userName: widget.session.name,
            callID: widget.session.bookingCode,
            events: ZegoUIKitPrebuiltCallEvents(
              onCallEnd: (event, defaultAction) {
                defaultAction();

                if (widget.session.isStudent) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RateSessionScreen(session: widget.session),
                    ),
                  );
                }
              },
            ),
            config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              ..avatarBuilder = (context, size, user, extraInfo) {
                final avatarUrl = userAvatars[user?.id] ?? "";

                if (avatarUrl.isNotEmpty) {
                  return Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }

                final firstLetter =
                    user?.name.characters.first.toUpperCase() ?? '?';

                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white10,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    firstLetter,
                    style: TextStyle(
                      fontSize: size.width * 0.4,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              ..bottomMenuBarConfig.buttons = [
                ZegoCallMenuBarButtonName.toggleMicrophoneButton,
                ZegoCallMenuBarButtonName.toggleCameraButton,
                ZegoCallMenuBarButtonName.switchCameraButton,
                ZegoCallMenuBarButtonName.hangUpButton,
                ZegoCallMenuBarButtonName.toggleScreenSharingButton,
              ]
              ..audioVideoViewConfig.foregroundBuilder =
                  (context, size, user, extraInfo) {
                return Positioned(
                  top: 20,
                  right: 20,
                  child: OutlinedButton(
                    onPressed: () {
                      isFullscreen = !isFullscreen;

                      ZegoUIKitPrebuiltCallController()
                          .screenSharing
                          .showViewInFullscreenMode(
                            user?.id ?? '',
                            isFullscreen,
                          );
                    },
                    child: const Text('Full Screen'),
                  ),
                );
              },
          ),
          StreamBuilder<List<ZegoUIKitUser>>(
            stream: ZegoUIKit().getUserListStream(),
            builder: (context, snapshot) {
              final remoteUsers = ZegoUIKit().getRemoteUsers();

              for (var user in remoteUsers) {
                if (!userAvatars.containsKey(user.id)) {
                  userAvatars[user.id] = widget.session.image ?? "";
                }
              }

              if (remoteUsers.isEmpty) {
                return _buildWaitingUI(
                  widget.session.name,
                  widget.session.image,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingUI(String name, String? avatarUrl) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B1D2A),
              Color(0xFF133B5C),
              Color(0xFF1E5F74),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPrettyAvatar(name, avatarUrl),
              const SizedBox(height: 30),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Waiting for $name ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connecting video call...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrettyAvatar(String name, String? avatarUrl) {
    final firstLetter =
        name.isNotEmpty ? name.characters.first.toUpperCase() : '?';

    return CircleAvatar(
      radius: 46,
      backgroundColor: Colors.white10,
      backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
          ? NetworkImage(avatarUrl)
          : null,
      child: (avatarUrl == null || avatarUrl.isEmpty)
          ? Text(
              firstLetter,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
