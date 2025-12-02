import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/home/widgets/custom_header.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_appbar.dart';

import '../../../constants/strings.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: "Notifications"),
            ],
          ),

          Positioned(
            top: 96,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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
                    icon: item.icon
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}