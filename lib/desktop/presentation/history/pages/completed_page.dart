import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/history/models/history_model.dart';

import '../widgets/history_card.dart';

class CompletedSessionsPage extends StatelessWidget {
  const CompletedSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> completedSessions = [
      HistoryModel(
        id: "1",
        name: "Joumana Johnson",
        role: "Web Developer",
        date: "Oct 3, 2025",
        time: "4:00 PM",
        duration: "60 min",
        status: "Finished",
        rating: 5,
        imageUrl: "assets/images/people_images/Joumana Johnson.png",
      ),
      HistoryModel(
        id: "1",
        name: "Lisa Wang",
        role: "UI/UX Developer",
        date: "Sep 26, 2025",
        time: "1:00 PM",
        duration: "45 min",
        status: "Finished",
        rating: 4,
        imageUrl: "assets/images/people_images/Lisa Wang.png",
      ),
      HistoryModel(
        id: "1",
        name: "Marcus Johnson",
        role: "Mobile Developer",
        date: "Sep 15, 2025",
        time: "5:30 PM",
        duration: "90 min",
        status: "Finished",
        rating: 0,
        imageUrl: "assets/images/people_images/Marcus Johnson.png",
      ),
      HistoryModel(
        id: "1",
        name: "Mark Anthony",
        role: "Backend Developer",
        date: "Sep 15, 2025",
        time: "5:30 PM",
        duration: "90 min",
        status: "Finished",
        rating: 0,
        imageUrl: "assets/images/people_images/Mark Anthony.jpg",
      ),
    ];
    return ListView.separated(
      //physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: completedSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: completedSessions[index]);
      },
    );
  }
}
