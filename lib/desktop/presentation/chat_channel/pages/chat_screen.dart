import 'package:flutter/material.dart';

import '../../../../desktop/presentation/chat_channel/models/message_model.dart';
import '../../../../shared/core/theme/app_palette.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0D035F),
                  child: Text(
                    widget.channelName[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.channelName,
                  style: const TextStyle(
                      color: Color(0xFF0D035F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: message.isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
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
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).cardColor,
                      hintText: "Message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).textTheme.bodyLarge!.color),
                  onPressed: _sendMessage,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}