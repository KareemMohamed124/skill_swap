import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
    // Load more when scrolled near the top (for older messages)
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final padding = screenWidth * 0.04;
    final avatarRadius = screenWidth * 0.06;
    final fontSizeName = screenWidth * 0.045;
    final fontSizeMessage = screenWidth * 0.04;
    final inputHeight = screenHeight * 0.065;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              SizedBox(height: padding),
              // Header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: screenWidth * 0.06),
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  CircleAvatar(
                    radius: avatarRadius,
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSizeName,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Text(
                      widget.partnerName,
                      style: TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeName,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Messages
              Expanded(
                child: BlocConsumer<PrivateChatMessagesCubit,
                    PrivateChatMessagesState>(
                  listener: (context, state) {
                    if (state is PrivateChatMessagesLoaded) {
                      // Auto scroll to bottom on new messages
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
                            Text(
                              'Failed to load messages',
                              style: TextStyle(fontSize: fontSizeMessage),
                            ),
                            SizedBox(height: screenHeight * 0.02),
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: fontSizeMessage,
                            ),
                          ),
                        );
                      }

                      final currentUserId = context
                          .read<PrivateChatMessagesCubit>()
                          .currentUserId;

                      return Column(
                        children: [
                          if (state.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(padding),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                final isMe = message.senderId == currentUserId;
                                return _chatBubble(
                                  message,
                                  isMe,
                                  fontSizeMessage,
                                  screenWidth,
                                );
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
              _messageInput(
                screenWidth: screenWidth,
                fontSizeMessage: fontSizeMessage,
                inputHeight: inputHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatBubble(ChatMessageModel message, bool isMe,
      double fontSizeMessage, double screenWidth) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Opacity(
        opacity: message.isPending ? 0.6 : 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
          padding: EdgeInsets.all(screenWidth * 0.035),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: isMe ? Colors.white : const Color(0xFF0D035F),
              fontSize: fontSizeMessage,
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageInput({
    required double screenWidth,
    required double fontSizeMessage,
    required double inputHeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: inputHeight,
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  hintText: "Message...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeMessage,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              size: screenWidth * 0.07,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
