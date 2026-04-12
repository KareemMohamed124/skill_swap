import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/common_ui/reply_bubble_preview.dart';
import '../../../shared/core/theme/app_palette.dart';
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

  String _formatTime(dynamic date) {
    try {
      final DateTime parsed = DateTime.parse(date.toString());
      return DateFormat('hh:mm a').format(parsed);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              mainAxisSize:
                  MainAxisSize.min, // مهم جدًا عشان البابل يضبط على طول النص
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
                if (message.isEdited)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'edited',
                      style: TextStyle(
                        fontSize: 9,
                        fontStyle: FontStyle.italic,
                        color: isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                const SizedBox(height: 3),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.createdAt),
                        style: TextStyle(
                          fontSize: 9,
                          color: isMe ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        if (message.status == MessageStatus.sending)
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.white70),
                        if (message.status == MessageStatus.failed)
                          const Icon(Icons.error, size: 14, color: Colors.red),
                        if (message.status == MessageStatus.sent)
                          Icon(
                            Icons.done_all,
                            size: 14,
                            color:
                                message.isSeen ? Colors.blue : Colors.white70,
                          ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
