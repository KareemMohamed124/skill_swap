import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/common_ui/reply_bubble_preview.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final String senderName;
  final String? senderImage;
  final bool showAvatar;
  final bool showName;
  final bool isTyping;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapReply;
  final bool isHighlighted;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.senderName,
    this.senderImage,
    this.showAvatar = true,
    this.showName = true,
    this.isTyping = false,
    this.onLongPress,
    this.onTapReply,
    this.isHighlighted = false,
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
    return CircleAvatar(
      backgroundColor: AppPalette.primary,
      backgroundImage: senderImage != null && senderImage!.isNotEmpty
          ? NetworkImage(senderImage!)
          : null,
      child: senderImage == null || senderImage!.isEmpty
          ? Text(
              senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bubbleColor = isMe ? AppPalette.primary : Colors.grey.shade300;

    final textColor = isMe ? Colors.white : Colors.black87;
    final time = _formatTime(message.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          /// avatar
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: showAvatar ? _buildAvatar() : const SizedBox(width: 32),
            ),

          Flexible(
            child: IntrinsicWidth(
              stepWidth: 0.1,
              child: GestureDetector(
                onLongPress: onLongPress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: isHighlighted ? AppPalette.warning.withOpacity(0.5) : bubbleColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isMe && showName)
                        Text(
                          senderName ?? "User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      if (!isMe && showName) const SizedBox(height: 3),
                      if (message.replyTo != null)
                        ReplyBubblePreview(
                          replyMessage: message.replyTo!,
                          isMe: isMe,
                          onTap: onTapReply ?? () {},
                        ),
                      isTyping
                          ? const TypingIndicator()
                          : Text(
                              message.content,
                              style: TextStyle(color: textColor),
                              softWrap: true,
                            ),
                      const SizedBox(height: 3),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (message.isEdited)
                              Text(
                                'edited  ',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontStyle: FontStyle.italic,
                                  color: isMe ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 9,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
