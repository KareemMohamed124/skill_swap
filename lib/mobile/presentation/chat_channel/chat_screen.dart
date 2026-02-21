import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/chat_channel/message_model.dart';

import '../../../shared/core/theme/app_palette.dart';

class ChatScreen extends StatefulWidget {
  final String channelName;

  const ChatScreen({super.key, required this.channelName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static Map<String, List<Message>> chats = {};

  List<Message> get messages => chats[widget.channelName] ?? [];

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
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    chats.putIfAbsent(widget.channelName, () => []);

    setState(() {
      chats[widget.channelName]!.add(
        Message(
          sender: "You",
          text: _controller.text.trim(),
          isMe: true,
          time: DateTime.now(),
        ),
      );
    });

    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    /// ✅ MediaQuery
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              Row(
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
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Text(
                          "No messages yet",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _chatBubble(messages[index]);
                        },
                      ),
              ),
              _messageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              message.isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? Colors.white : const Color(0xFF0D035F),
          ),
        ),
      ),
    );
  }

  Widget _messageInput() {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

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
