import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/dependency_injection/injection.dart';
import 'message_bubble.dart';

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
  late PublicChatMessagesCubit _chatCubit;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatCubit = sl<PublicChatMessagesCubit>();
    _chatCubit.init(widget.chatId, isPrivate: false);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _chatCubit.sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageList(List messages) {
    return ListView.builder(
        controller: _scrollController,
        //     reverse: true,
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isMe = message.senderId.id == _chatCubit.currentUserId;

          bool showAvatar = true;
          bool showName = true;

          if (index > 0) {
            final previousMessage = messages[index - 1];

            if (previousMessage.senderId.id == message.senderId.id) {
              showAvatar = false;
              showName = false;
            }
          }

          return MessageBubble(
            message: message,
            isMe: isMe,
            senderName: "User",
            senderImage: message.senderId.userImage.secureUrl,
            showAvatar: showAvatar,
            showName: showName,
          );
        });
  }

  Widget _messageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Message...",
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppPalette.primary,
                child: Text(
                  widget.channelName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.channelName,
                style: const TextStyle(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  BlocBuilder<PublicChatMessagesCubit, PublicChatMessagesState>(
                builder: (context, state) {
                  if (state is PublicChatMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PublicChatMessagesLoaded) {
                    return _buildMessageList(state.messages);
                  }

                  if (state is PublicChatMessagesError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox();
                },
              ),
            ),
            _messageInput(),
          ],
        ),
      ),
    );
  }
}
