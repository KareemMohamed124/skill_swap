import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/common_ui/base_screen.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late GetBookingsCubit getBookingsCubit;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getBookingsCubit = sl<GetBookingsCubit>();
    getBookingsCubit.fetchAllBookings("all");

    // تحديث الوقت كل 30 ثانية
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return "${diff.inSeconds}s ago";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BaseScreen(
      title: "notification".tr,
      child: BlocBuilder<GetBookingsCubit, GetBookingsState>(
        bloc: getBookingsCubit,
        builder: (context, state) {
          if (state is GetBookingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetBookingsError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is GetBookingsLoaded) {
            final now = DateTime.now();

            final notifications = state.bookings.map((session) {
              // بناء DateTime من date + time
              final dateTime = session.dateTime;

              Color tagColor;
              String tag;
              String title;
              IconData icon;

              switch (session.rawStatus) {
                case "accepted":
                  tag = "Approved";
                  tagColor = Colors.green;
                  icon = Icons.check_circle_outline;
                  if (dateTime.isAfter(now) &&
                      dateTime.difference(now).inMinutes <= 30) {
                    title =
                        "Reminder: Your mentorship session starts in ${dateTime.difference(now).inMinutes} minutes.";
                  } else {
                    title = "Your session has been Approved!";
                  }
                  break;

                case "rejected":
                  tag = "Rejected";
                  tagColor = Colors.red;
                  icon = Icons.cancel_outlined;
                  title = "Your session request was declined.";
                  break;

                case "cancelled":
                  tag = "Cancelled";
                  tagColor = Colors.red.shade300;
                  icon = Icons.cancel_outlined;
                  title = "Your session was cancelled.";
                  break;

                default:
                  tag = "Reminder";
                  tagColor = Colors.grey;
                  icon = Icons.notifications_none_outlined;
                  title = "You have a new session request.";
              }

              return NotificationModel(
                bgColor: tagColor.withOpacity(0.1),
                borderColor: tagColor,
                tag: tag,
                tagColor: tagColor,
                timeAgo: _formatTimeAgo(dateTime),
                title: title,
                mentorName: session.name,
                sessionTime:
                    "${dateTime.day}/${dateTime.month} at ${DateFormat('h:mm a').format(dateTime)}",
                icon: icon,
                dateTime: dateTime, // مهم للترتيب
              );
            }).toList();

            // ترتيب من الأحدث للأقدم
            notifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));

            return ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.04),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
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
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
