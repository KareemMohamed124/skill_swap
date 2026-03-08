import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../shared/bloc/private_chat/private_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/chat/chat_models.dart';

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
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels <=
            _scrollController.position.minScrollExtent + 100) {
      context.read<PrivateChatMessagesCubit>().loadMore();
    }
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
    if (_controller.text.trim().isEmpty) return;
    context.read<PrivateChatMessagesCubit>().sendMessage(_controller.text);
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

                  if (state is PrivateChatMessagesLoaded) {
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

                    final currentUserId =
                        context.read<PrivateChatMessagesCubit>().currentUserId;

                    return Column(
                      children: [
                        if (state.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              final isMe = message.senderId == currentUserId;
                              return _chatBubble(message, isMe);
                            },
                          ),
                        ),
                      ],
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

  Widget _chatBubble(ChatMessageModel message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Opacity(
        opacity: message.isPending ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: isMe ? Colors.white : const Color(0xFF0D035F),
            ),
          ),
        ),
      ),
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
}
