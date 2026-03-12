import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/core/theme/app_palette.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final dynamic message;
  final bool isMe;
  final String? senderName;
  final String? senderImage;
  final bool isTyping;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.senderName,
    this.senderImage,
    this.isTyping = false,
  });

  String _formatTime(dynamic date) {
    try {
      final DateTime parsed = DateTime.parse(date.toString());
      return DateFormat('hh:mm a').format(parsed);
    } catch (_) {
      return '';
    }
  }

  Widget _buildAvatar() {
    if (senderImage != null && senderImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(senderImage!),
      );
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: AppPalette.primary,
      child: Text(
        senderName != null && senderName!.isNotEmpty
            ? senderName![0].toUpperCase()
            : "?",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? AppPalette.primary : Colors.grey[300];
    final textColor = isMe ? Colors.white : Colors.black87;
    final time = _formatTime(message.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          /// صورة المرسل (لو مش أنا)
          if (!isMe) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],

          /// الرسالة
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              /// اسم المرسل
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    senderName ?? "User",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

              /// البابل
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                constraints: const BoxConstraints(maxWidth: 260),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// النص
                    isTyping
                        ? const TypingIndicator()
                        : Text(
                            message.content ?? message['text'] ?? '',
                            style: TextStyle(color: textColor),
                          ),

                    const SizedBox(height: 4),

                    /// الوقت
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
