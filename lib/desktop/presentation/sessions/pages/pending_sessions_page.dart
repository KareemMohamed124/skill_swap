import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/sessions/models/session.dart';
import 'package:skill_swap/desktop/presentation/sessions/widgets/session_card.dart';
import 'package:skill_swap/shared/constants/strings.dart' ;

class PendingSessionsPage extends StatelessWidget {
  const PendingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
   List<Session> pendingList = [
      Session(
          id: "1",
          image: "assets/images/people_images/Marcus Johnson.png",
          name: "Marcus Johnson",
          role: "Mentor",
          type: "Video Call",
          dateTime: DateTime.now(),
          price: "25",
          status: "PendingApproval",
          timeAgo: ""
      ),
      Session(
          id: "2",
          image: "assets/images/people_images/Sarah Smith.png",
          name: "Sarah Smith",
          role: "Mentor",
          type: "1:1 Session",
          dateTime: DateTime.now().add(const Duration(days: 1)),
          price: "30",
          status: "PendingApproval",
          timeAgo: ""
      ),
      Session(
          id: "3",
          image: "assets/images/people_images/Alex Brown.png",
          name: "Alex Brown",
          role: "Mentor",
          type: "Video Call",
          dateTime: DateTime.now().add(const Duration(days: 2)),
          price: "20",
          status: "PendingApproval",
          timeAgo: ""
      ),
    ];

    return  ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: pendingList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return SessionCard(session: pendingList[index]);
      },
    );
  }
}