import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/prv_chat/prv_message_bubble.dart';

import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String partnerName;
  final String partnerId;
  final String? partnerImage;

  const PrivateChatScreen({
    super.key,
    required this.chatId,
    required this.partnerId,
    required this.partnerName,
    this.partnerImage,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  late PublicChatMessagesCubit _chatCubit;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<PublicChatMessagesCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<PublicChatMessagesCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  Widget _buildMessageList(List messages) {
    final currentUserId = _chatCubit.currentUserId;

    return ListView.builder(
      controller: _scrollController,
      // reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId.id == currentUserId;

        return PrvMessageBubble(
          message: message.content ?? '',
          isMe: isMe,
        );
      },
    );
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
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
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
              backgroundImage:
                  widget.partnerImage != null && widget.partnerImage!.isNotEmpty
                      ? NetworkImage(widget.partnerImage!)
                      : null,
              child: widget.partnerImage == null || widget.partnerImage!.isEmpty
                  ? Text(
                      widget.partnerName.isNotEmpty
                          ? widget.partnerName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              widget.partnerName,
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
                BlocConsumer<PublicChatMessagesCubit, PublicChatMessagesState>(
              listener: (context, state) {
                if (state is PublicChatMessagesLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is PublicChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PublicChatMessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    );
                  }
                  return _buildMessageList(state.messages);
                }

                if (state is PublicChatMessagesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to load messages'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context
                              .read<PublicChatMessagesCubit>()
                              .loadMessages(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          _messageInput(),
        ],
      ),
    );
  }
}
