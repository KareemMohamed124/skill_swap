import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../shared/bloc/private_chat/private_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../mobile/presentation/chat_channel/message_bubble.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String partnerName;
  final String? partnerImage;

  const PrivateChatScreen({
    super.key,
    required this.chatId,
    required this.partnerName,
    this.partnerImage,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<PrivateChatMessagesCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  Widget _buildMessageList(List messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final currentUserId =
            context.read<PrivateChatMessagesCubit>().currentUserId;
        final isMe = message.senderId == currentUserId;

        bool showAvatar = true;
        bool showName = true;

        if (index > 0) {
          final previousMessage = messages[index - 1];
          if (previousMessage.senderId == message.senderId) {
            showAvatar = false;
            showName = false;
          }
        }

        return MessageBubble(
          message: message,
          isMe: isMe,
          senderName: isMe ? 'You' : widget.partnerName,
          senderImage: isMe ? null : widget.partnerImage,
          showAvatar: showAvatar,
          showName: showName,
        );
      },
    );
  }

  Widget _messageInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                hintText: "Message...",
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send,
                color: Theme.of(context).textTheme.bodyLarge!.color),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor:
          isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppPalette.primary,
                  backgroundImage: widget.partnerImage != null &&
                          widget.partnerImage!.isNotEmpty
                      ? NetworkImage(widget.partnerImage!)
                      : null,
                  child: widget.partnerImage == null ||
                          widget.partnerImage!.isEmpty
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
            const SizedBox(height: 16),
            // Messages
            Expanded(
              child: BlocConsumer<PrivateChatMessagesCubit,
                  PrivateChatMessagesState>(
                listener: (context, state) {
                  if (state is PrivateChatMessagesLoaded) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is PrivateChatMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PrivateChatMessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      );
                    }
                    return _buildMessageList(state.messages);
                  }

                  if (state is PrivateChatMessagesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Failed to load messages'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context
                                .read<PrivateChatMessagesCubit>()
                                .loadMessages(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            // Input
            _messageInput(),
          ],
        ),
      ),
    );
  }
}
