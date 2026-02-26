import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/session.dart';

class SessionCard extends StatelessWidget {
  final SessionModel session;

  const SessionCard({super.key, required this.session});

  // ================== STATUS ==================

  bool get isPending => session.rawStatus == "pending";

  bool get isAccepted => session.rawStatus == "accepted";

  bool get isRequested => session.rawStatus == "requested";

  bool get isCompleted => session.rawStatus == "completed";

  bool get isCancelled => session.rawStatus == "cancelled";

  bool get isRejected => session.rawStatus == "rejected";

  Color get badgeColor {
    if (isPending) return Colors.orange;
    if (isAccepted) return Colors.blue;
    if (isCompleted) return Colors.green;
    if (isCancelled || isRejected) return Colors.red;
    return Colors.grey;
  }

  String get badgeText {
    if (isPending) return "Pending";
    if (isAccepted) return "Accepted";
    if (isCompleted) return "Completed";
    if (isCancelled) return "Cancelled";
    if (isRejected) return "Rejected";
    return "";
  }

  String get timeAgo {
    final now = DateTime.now();
    final duration = now.difference(session.dateTime);

    if (duration.inMinutes < 60) return "${duration.inMinutes} min ago";
    if (duration.inHours < 24) return "${duration.inHours} h ago";
    return "${duration.inDays} d ago";
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  session.image,
                  width: screenWidth * 0.13,
                  height: screenWidth * 0.13,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(session.role,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),

              /// لو طلب جديد → يظهر الوقت
              if (isRequested)
                Text(timeAgo, style: Theme.of(context).textTheme.bodySmall)

              /// غير كده يظهر badge
              else
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenWidth * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    border: Border.all(color: badgeColor),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: screenWidth * 0.04),

          // ===== TIME =====
          iconText(
            context: context,
            icon: Icons.access_time,
            data:
                "${session.dateTime.hour}:${session.dateTime.minute.toString().padLeft(2, '0')}",
            screenWidth: screenWidth,
          ),

          SizedBox(height: screenWidth * 0.02),

          // ===== DATE =====
          iconText(
            context: context,
            icon: Icons.calendar_today_outlined,
            data:
                "${session.dateTime.day}/${session.dateTime.month}/${session.dateTime.year}",
            screenWidth: screenWidth,
          ),

          SizedBox(height: screenWidth * 0.02),

          // ===== PRICE =====
          iconText(
            context: context,
            icon: Icons.attach_money,
            data: session.price,
            screenWidth: screenWidth,
          ),

          SizedBox(height: screenWidth * 0.04),

          // ===== ACTIONS =====

          /// طلب جديد → Accept / Decline
          if (isRequested)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print("Accept ${session.name}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(
                      "accept".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      print("Decline ${session.name}");
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(
                      "decline".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ),
              ],
            )

          /// باقي الحالات
          else
            Container(
              height: screenWidth * 0.11,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPending
                    ? Colors.grey.shade300
                    : (isAccepted
                        ? Theme.of(context).primaryColor
                        : Colors.green),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Text(
                isPending
                    ? "pending_approval".tr
                    : (isAccepted ? "pay_now".tr : "join_now".tr),
                style: TextStyle(
                  color: isPending ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ================== ICON TEXT ==================

Widget iconText({
  required BuildContext context,
  required IconData icon,
  required String data,
  required double screenWidth,
}) {
  final textColor = Theme.of(context).textTheme.bodyMedium!.color;

  return Row(
    children: [
      Icon(icon,
          size: screenWidth * 0.045,
          color: data == "Free" ? Colors.green : textColor),
      SizedBox(width: screenWidth * 0.015),
      Flexible(
        child: Text(
          data,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: screenWidth * 0.035,
                color: data == "Free" ? Colors.green : null,
              ),
        ),
      ),
    ],
  );
}
