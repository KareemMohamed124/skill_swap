import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../shared/bloc/private_chat/private_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/dependency_injection/injection.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String channelName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.channelName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PrivateChatMessagesCubit _chatCubit;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _chatCubit = sl<PrivateChatMessagesCubit>()..init(widget.chatId);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _chatCubit.sendMessage(text);
    _controller.clear();
  }

  Widget _buildMessageList(List messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        final isMe =
            message.senderId.toString() == _chatCubit.currentUserId.toString();

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? AppPalette.primary : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.content ?? "",
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type message...",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: AppPalette.primary),
              onPressed: _sendMessage,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatCubit.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.channelName),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<PrivateChatMessagesCubit,
                  PrivateChatMessagesState>(
                builder: (context, state) {
                  if (state is PrivateChatMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PrivateChatMessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(child: Text("No messages"));
                    }

                    return _buildMessageList(state.messages);
                  }

                  return const SizedBox();
                },
              ),
            ),
            _buildInput(),
          ],
        ),
      ),
    );
  }
}
