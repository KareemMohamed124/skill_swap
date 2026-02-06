import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/constants/strings.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BaseScreen(
        title: "notification".tr,
        child: ListView.builder(
          padding: EdgeInsets.all(screenWidth * 0.04), // بدل 16
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
        ));
  }
}
