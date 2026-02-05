import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/sessions/models/session.dart';
import 'package:skill_swap/desktop/presentation/sessions/widgets/session_card.dart';

import '../../../../shared/constants/strings.dart';

class UpcomingSessionsPage extends StatelessWidget {
  const UpcomingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Session> confirmedList = [
      Session(
          id: "1",
          image: "assets/images/people_images/Joumana Johnson.png",
          name: "Joumana Johnson",
          role: "Mentor",
          type: "Video Session",
          dateTime: DateTime(2025, 1, 12, 10, 30),
          price: "35",
          status: "Confirmed",
          timeAgo: ""
      ),
      Session(
          id: "2",
          image: "assets/images/people_images/Leo Wong.png",
          name: "Leo Wong",
          role: "Software Engineer",
          type: "Video Call",
          dateTime: DateTime(2025, 1, 12, 14, 00),
          price: "40",
          status: "Confirmed",
          timeAgo: ""
      ),
      Session(
          id: "3",
          image: "assets/images/people_images/Marcus Johnson.png",
          name: "Marcus Johnson",
          role: "Student",
          type: "1:1 Session",
          dateTime: DateTime(2025, 1, 13, 11, 00),
          price: "Free",
          status: "Live Now",
          timeAgo: ""
      ),
      Session(
          id: "4",
          image: "assets/images/people_images/Sarah Smith.png",
          name: "Sarah Smith",
          role: "UI/UX Designer",
          type: "Video Session",
          dateTime: DateTime(2025, 1, 13, 16, 30),
          price: "Free",
          status: "Live Now",
          timeAgo: ""
      ),
      Session(
          id: "5",
          image: "assets/images/people_images/Ahmed Ibrahim.png",
          name: "Ahmed Ibrahim",
          role: "Mobile Developer",
          type: "Video Call",
          dateTime: DateTime(2025, 1, 14, 12, 00),
          price: "28",
          status: "Confirmed",
          timeAgo: ""
      ),
      Session(
          id: "6",
          image: "assets/images/people_images/Mariam Nasser.png",
          name: "Mariam Nasser",
          role: "Data Scientist",
          type: "1:1 Session",
          dateTime: DateTime(2025, 1, 14, 18, 00),
          price: "45",
          status: "Confirmed",
          timeAgo: ""
      ),
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: confirmedList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return SessionCard(session:  confirmedList[index]);
      },
    );
  }
}