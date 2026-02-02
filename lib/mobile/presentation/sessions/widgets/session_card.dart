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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
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
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: Theme.of(context).textTheme.titleMedium
                    ),

                    Text(
                      session.role,
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                  ],
                ),
              ),
                if(isRequest)
                  Text(
                    session.timeAgo,
                    style: Theme.of(context).textTheme.bodySmall
                  ),
              if (!isRequest)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: badgeColor),
                  ),
                  ///////////////////////////////////
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          iconText(
            context: context,
              icon: Icons.access_time,
              data: "1h session"
          ),
          // Row(
          //   children: [
          //     iconText(
          //         icon: Icons.access_time,
          //         data: "1h session"
          //     ),
          //     const SizedBox(width: 32),
          //     iconText(
          //         icon: Icons.chat_bubble_outline,
          //         data: session.type
          //     ),
          //   ],
          // ),
          const SizedBox(height: 8),
          iconText(
            context: context,
              icon: Icons.calendar_today_outlined,
              data:  "${session.dateTime.day}/${session.dateTime.month}/${session.dateTime.year} "
                  "at ${session.dateTime.hour}:${session.dateTime.minute.toString().padLeft(2, '0')} PM"
          ),
          const SizedBox(height: 8),
        iconText(
          context: context,
            icon: Icons.attach_money,
            data: session.price
        ),

          const SizedBox(height: 16),

          if (isRequest)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "accept".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "decline".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              height: 44,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                 color: isPending ? Colors.grey.shade300 : (isConfirmed ? Theme.of(context).primaryColor : Colors.green),
                //color: isConfirmed ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPending ? "pending_approval".tr : (
                    isConfirmed ?  "pay_now".tr : "join_now".tr
                ),
                //isConfirmed ? "Join Now" : "Pending Approval",
                style: TextStyle(
                  color: isPending ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


Widget iconText({required BuildContext context, required IconData icon, required String data}) {
     final textColor = Theme.of(context).textTheme.bodyMedium!.color;
  return  Row(
    children: [
       Icon(icon, size: 18, color: data == "Free" ? Colors.green : textColor
       ),
      const SizedBox(width: 6),
      Text(
          data,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: data == "Free" ? Colors.green : null
        )
      ),
    ],
  );
}