import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';

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
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Row(
               children: [
                 Icon(icon, size: 18, color: tagColor,),
                 SizedBox(width: 4,),
                 Container(
                   padding:
                   const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                   decoration: BoxDecoration(
                     color: tagColor.withValues(alpha: .15),
                     borderRadius: BorderRadius.circular(8),
                   ),
                   child: Text(
                     tag,
                     style: TextStyle(
                       color: tagColor,
                       fontSize: 12,
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                 ),
               ],
             ),
              Text(
                timeAgo,
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Mentor: $mentorName",
            style: TextStyle(
              color: AppColor.mainColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          if (sessionTime.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  sessionTime,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
        ],
      ),
    );
  }
}