import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      session.role,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
                if(isRequest)
                  Text(
                    session.timeAgo,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
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
              icon: Icons.calendar_today_outlined,
              data:  "${session.dateTime.day}/${session.dateTime.month}/${session.dateTime.year} "
                  "at ${session.dateTime.hour}:${session.dateTime.minute.toString().padLeft(2, '0')} PM"
          ),
          const SizedBox(height: 8),
        iconText(
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
                    child: const Text(
                      "Accept",
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
                    child: const Text(
                      "Decline",
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
                 color: isPending ? Colors.grey.shade300 : (isConfirmed ? AppColor.mainColor : Colors.green),
                //color: isConfirmed ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPending ? "Pending Approval" : (
                    isConfirmed ?  "Pay Now" : "Join Now"
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


Widget iconText({required IconData icon, required String data}) {
  return  Row(
    children: [
       Icon(icon, size: 18, color: data == "Free" ? Colors.green : Colors.black
       ),
      const SizedBox(width: 6),
      Text(
          data,
        style: TextStyle(
          color: data == "Free" ? Colors.green : Colors.black
        ),
      ),
    ],
  );
}