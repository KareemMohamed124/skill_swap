import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../models/session.dart';
import '../widgets/session_card.dart';

class RequestsSessionsPage extends StatelessWidget {
  const RequestsSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
     List<Session> requestList = [
      Session(
          id: "1",
          image: "assets/images/people_images/Alex Johnson.png",
          name: "Alex Johnson",
          role: "React Development",
          type: "Video Session",
          dateTime: DateTime(2025, 1, 10, 11, 00),
          price: "Free",
          status: "NewRequest",
          timeAgo: "10 min ago"
      ),
      Session(
          id: "2",
          image: "assets/images/people_images/Moritz Garcia.png",
          name: "Moritz Garcia",
          role: "System Engineering",
          type: "Video Call",
          dateTime: DateTime(2025, 1, 10, 14, 30),
          price: "Free",
          status: "NewRequest",
          timeAgo: "2 hours ago"
      ),
      Session(
          id: "3",
          image: "assets/images/people_images/Aya Ahmed.png",
          name: "Aya Ahmed",
          role: "UI/UX Design",
          type: "1:1 Session",
          dateTime: DateTime(2025, 1, 11, 16, 00),
          price: "Free",
          status: "NewRequest",
          timeAgo: "5 hours ago"
      ),
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: requestList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return SessionCard(session: requestList[index]);
      },
    );

  }
}