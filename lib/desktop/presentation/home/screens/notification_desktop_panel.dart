import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/notification_card.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/core/theme/app_palette.dart';

class NotificationDesktopPanel extends StatefulWidget {
  const NotificationDesktopPanel({super.key});

  @override
  State<NotificationDesktopPanel> createState() => _NotificationDesktopPanelState();
}

class _NotificationDesktopPanelState extends State<NotificationDesktopPanel> {
  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Notifications",
              style: TextStyle(
                color: Color(0xFFD6D6D6),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 20),
          SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
             padding: EdgeInsets.all(16),
              itemCount: AppData.notificationCard.length,
              itemBuilder: (context, index) {
                final item = AppData.notificationCard[index];

                return NotificationCard(
                  bgColor: item.bgColor,
                  borderColor: item.borderColor,
                  tag: item.tag,
                  tagColor: item.tagColor,
                  timeAgo: item.timeAgo,
                  title: item.title,
                  mentorName: item.mentorName,
                  sessionTime: item.sessionTime,
                  icon: item.icon,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}