import 'package:flutter/material.dart';
import 'message_model.dart';
import 'package:get/get.dart';


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

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundColor: const Color(0xFF0D035F),
      //         child: Text(
      //           widget.otherUserName[0],
      //           style: const TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //       const SizedBox(width: 10),
      //       Text(
      //         widget.otherUserName,
      //         style: const TextStyle(
      //           color: Color(0xFF0D035F),
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16) ,
        child: Column(
          children: [
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: (){
                      Get.back();
                    }
                ),
                SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: const Color(0xFF0D035F),
                  child: Text(
                    widget.otherUserName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.otherUserName,
                  style: const TextStyle(
                      color: Color(0xFF0D035F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child:
              messages.isEmpty
                  ? const Center(
                child: Text(
                  "No messages yet",
                  style: TextStyle(color: Color(0xFF0D035F)),
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.senderId == widget.currentUserId;
                  return _chatBubble(message, isMe);
                },
              ),
            ),
            _messageInput(),
          ],
        ),
      )
    );
  }

  Widget _chatBubble(Message message, bool isMe) {
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
          message.text,
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF0D035F),
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
              decoration: InputDecoration(
                hintText: "Message...",
                hintStyle: const TextStyle(
                  color: Color(0xFF0D035F),
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
            icon: const Icon(Icons.send, color: Color(0xFF0D035F)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}