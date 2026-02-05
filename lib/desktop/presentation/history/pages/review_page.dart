import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/history/models/history_model.dart';

import '../../../../shared/constants/strings.dart';
import '../widgets/history_card.dart';

class ReviewSessionsPage extends StatelessWidget {
  const ReviewSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> receivedReviews = [

      HistoryModel(
        id: 1,
        name: "Joumana Johnson",
        role: "Web Developer",
        date: "Oct 5, 2025",
        time: "6:00 PM",
        duration: "60 min",
        status: "Review",
        rating: 5,
        imageUrl: "assets/images/people_images/Joumana Johnson.png",
        reviewComment: "Great mentor! Very clear and helpful.",
        isReviewReceived: true,
      ),

      HistoryModel(
        id: 2,
        name: "Lisa Wang",
        role: "UI/UX Developer",
        date: "Sep 29, 2025",
        time: "2:00 PM",
        duration: "45 min",
        status: "Review",
        rating: 4,
        imageUrl: "assets/images/people_images/Lisa Wang.png",
        reviewComment: "Explained concepts very well.",
        isReviewReceived: true,
      ),

      HistoryModel(
        id: 3,
        name: "Marcus Johnson",
        role: "Mobile Developer",
        date: "Sep 15, 2025",
        time: "5:30 PM",
        duration: "90 min",
        status: "Finished",
        rating: 0,
        imageUrl: "assets/images/people_images/Marcus Johnson.png",
        isReviewReceived: false,
      ),

      HistoryModel(
        id: 4,
        name: "Sarah Adams",
        role: "Mobile Developer",
        date: "Oct 1, 2025",
        time: "3:00 PM",
        duration: "60 min",
        status: "Cancelled",
        rating: 0,
        imageUrl: "assets/images/people_images/Sarah Adams.jpg",
        isReviewReceived: false,
      ),
    ];
    return  ListView.separated(
      //  physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: receivedReviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: receivedReviews[index]);
      },
    );
  }
}