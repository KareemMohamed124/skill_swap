import 'package:flutter/material.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/common_ui/reply_bubble_preview.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';

class PrvMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapReply;
  final bool isHighlighted;

  const PrvMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onLongPress,
    this.onTapReply,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isHighlighted 
                ? AppPalette.warning.withOpacity(0.5) 
                : (isMe ? AppPalette.primary : Colors.grey.shade300),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft:
              isMe ? const Radius.circular(14) : const Radius.circular(0),
              bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.replyTo != null) ...[
                ReplyBubblePreview(
                  replyMessage: message.replyTo!,
                  isMe: isMe,
                  onTap: onTapReply ?? () {},
                ),
                const SizedBox(height: 4),
              ],
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
