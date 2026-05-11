import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_list.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_screen.dart';

import '../../common/desktop_scaffold.dart';

class ChatChannelDesktop extends StatefulWidget {
  const ChatChannelDesktop({super.key});

  @override
  State<ChatChannelDesktop> createState() => _ChatChannelDesktopState();
}

class _ChatChannelDesktopState extends State<ChatChannelDesktop> {
  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      body: ChatListScreen(),
      rightPanel: ChatScreen(channelName: '',),
    );
  }
}
