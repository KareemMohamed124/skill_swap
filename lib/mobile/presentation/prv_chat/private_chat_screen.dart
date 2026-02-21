import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/core/theme/app_palette.dart';
import 'message_model.dart';

class PrivateChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  const PrivateChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static Map<String, List<Message>> privateChats = {};

  String get chatId {
    final ids = [widget.currentUserId, widget.otherUserId]..sort();
    return ids.join("_");
  }

  List<Message> get messages => privateChats[chatId] ?? [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    privateChats.putIfAbsent(chatId, () => []);

    setState(() {
      privateChats[chatId]!.add(
        Message(
          senderId: widget.currentUserId,
          text: _controller.text.trim(),
          time: DateTime.now(),
        ),
      );
    });

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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final padding = screenWidth * 0.04;
    final avatarRadius = screenWidth * 0.06;
    final fontSizeName = screenWidth * 0.045;
    final fontSizeMessage = screenWidth * 0.04;
    final fontSizeTime = screenWidth * 0.035;
    final inputHeight = screenHeight * 0.065;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(height: padding),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: screenWidth * 0.06),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(width: screenWidth * 0.04),
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppPalette.primary,
                  child: Text(
                    widget.otherUserName[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeName,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  widget.otherUserName,
                  style: TextStyle(
                    color: AppPalette.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeName,
                  ),
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
                          fontSize: fontSizeMessage,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(padding),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == widget.currentUserId;
                        return _chatBubble(
                            message, isMe, fontSizeMessage, screenWidth);
                      },
                    ),
            ),
            _messageInput(
                screenWidth: screenWidth,
                fontSizeMessage: fontSizeMessage,
                inputHeight: inputHeight),
          ],
        ),
      ),
    );
  }

  Widget _chatBubble(
      Message message, bool isMe, double fontSizeMessage, double screenWidth) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
        padding: EdgeInsets.all(screenWidth * 0.035),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF0D035F),
            fontSize: fontSizeMessage,
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
