import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final String tag;
  final Color tagColor;
  final String timeAgo;
  final String title;
  final String mentorName;
  final String sessionTime;
  final IconData icon;

  const NotificationCard({
    super.key,
    required this.bgColor,
    required this.borderColor,
    required this.tag,
    required this.tagColor,
    required this.timeAgo,
    required this.title,
    required this.mentorName,
    required this.sessionTime,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
<<<<<<< HEAD
            //color: Theme.of(context).cardColor,
=======
            color: Theme.of(context).cardColor,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON + TAG + TIME
              Row(
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: tagColor,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
<<<<<<< HEAD
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: tagColor,
                            fontWeight: FontWeight.w500,
                          ),
=======
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        fontSize: 11,
                        color: tagColor,
                        fontWeight: FontWeight.w500,
                      ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeAgo,
<<<<<<< HEAD
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
=======
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      fontSize: 11,
                    ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// TITLE
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
<<<<<<< HEAD
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      height: 1.3,
                    ),
=======
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  fontSize: 13,
                  height: 1.3,
                ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),

              const SizedBox(height: 6),

              /// MENTOR
              Text(
                "Mentor: $mentorName",
<<<<<<< HEAD
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
=======
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),

              if (sessionTime.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
<<<<<<< HEAD
                      color: Theme.of(context).textTheme.bodyMedium?.color,
=======
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sessionTime,
<<<<<<< HEAD
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
=======
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontSize: 12,
                      ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
