import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/session.dart';

class SessionCard extends StatelessWidget {
  final Session session;

  const SessionCard({super.key, required this.session});

  bool get isPending => session.status == "PendingApproval";

  bool get isConfirmed => session.status == "Confirmed";

  bool get isRequest => session.status == "NewRequest";

  bool get isLive => session.status == "Live Now";

  Color get badgeColor {
    if (isPending) return Colors.orange;
    if (isConfirmed) return Colors.blue;
    if (isLive) return Colors.green;
    return Colors.grey;
  }

  String get badgeText {
    if (isPending) return "Pending";
    if (isConfirmed) return "Confirmed";
    if (isLive) return "Live Now";
    return "";
  }

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
              if (isRequest)
                Text(session.timeAgo,
                    style: Theme.of(context).textTheme.bodySmall),
              if (!isRequest)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenWidth * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
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
          iconText(
            context: context,
            icon: Icons.access_time,
            data: "1h session",
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenWidth * 0.02),
          iconText(
            context: context,
            icon: Icons.calendar_today_outlined,
            data:
                "${session.dateTime.day}/${session.dateTime.month}/${session.dateTime.year} "
                "at ${session.dateTime.hour}:${session.dateTime.minute.toString().padLeft(2, '0')} PM",
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenWidth * 0.02),
          iconText(
            context: context,
            icon: Icons.attach_money,
            data: session.price,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenWidth * 0.04),
          if (isRequest)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: screenWidth * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
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
                  child: Container(
                    height: screenWidth * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    child: Text(
                      "decline".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              height: screenWidth * 0.11,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPending
                    ? Colors.grey.shade300
                    : (isConfirmed
                        ? Theme.of(context).primaryColor
                        : Colors.green),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Text(
                isPending
                    ? "pending_approval".tr
                    : (isConfirmed ? "pay_now".tr : "join_now".tr),
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
