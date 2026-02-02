import 'package:flutter/material.dart';
import '../../../../shared/common_ui/header.dart';
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
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration:  BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
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