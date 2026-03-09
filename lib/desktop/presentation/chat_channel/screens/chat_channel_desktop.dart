import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../common/desktop_scaffold.dart';
import '../pages/chat_list.dart';
import '../pages/chat_screen.dart';

class ChatChannelDesktop extends StatefulWidget {
  const ChatChannelDesktop({super.key});

  @override
  State<ChatChannelDesktop> createState() => _ChatChannelDesktopState();
}

class _ChatChannelDesktopState extends State<ChatChannelDesktop> {
  String? _selectedChatId;
  String? _selectedChannelName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TracksBloc>()..add(LoadTracksEvent()),
      child: DesktopScaffold(
        body: ChatListScreen(
          selectedChannel: _selectedChannelName,
          onChannelSelected: (chatId, channelName) {
            setState(() {
              _selectedChatId = chatId;
              _selectedChannelName = channelName;
            });
          },
        ),
        rightPanel: _selectedChatId != null && _selectedChannelName != null
            ? ChatScreen(
                key: ValueKey(_selectedChatId),
                chatId: _selectedChatId!,
                channelName: _selectedChannelName!,
              )
            : Center(
                child: Text(
                  'Select a channel to start chatting',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }
}
