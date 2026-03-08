import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late PrivateChatMessagesCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = sl<PrivateChatMessagesCubit>();
    _chatCubit.init(widget.chatId);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
              _scrollController.position.minScrollExtent + 100 &&
          _chatCubit.state is PrivateChatMessagesLoaded) {
        _chatCubit.loadMore(); // Load older messages when scroll to top
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _chatCubit.sendMessage(text);
    _controller.clear();
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildHeader(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Expanded(child: _buildMessageList(screenWidth)),
              _buildMessageInput(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
        SizedBox(width: screenWidth * 0.04),
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
              fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildMessageList(double screenWidth) {
    return BlocBuilder<PrivateChatMessagesCubit, PrivateChatMessagesState>(
      builder: (context, state) {
        if (state is PrivateChatMessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PrivateChatMessagesError) {
          return Center(child: Text(state.message));
        }

        if (state is PrivateChatMessagesLoaded) {
          final messages = state.messages;
          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(screenWidth * 0.04),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _chatBubble(message.senderId == _chatCubit.currentUserId,
                  message.content);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _chatBubble(bool isMe, String text) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF0D035F),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                hintText: "Message...",
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
