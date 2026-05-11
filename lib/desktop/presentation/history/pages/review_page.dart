import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/mobile/presentation/history/models/history_model.dart';
import 'package:skill_swap/shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';

import '../widgets/history_card.dart';

class ReviewSessionsPage extends StatefulWidget {
  const ReviewSessionsPage({super.key});

  @override
  State<ReviewSessionsPage> createState() => _ReviewSessionsPageState();
}

class _ReviewSessionsPageState extends State<ReviewSessionsPage> {
  late Future<List<HistoryModel>> future;

  @override
  void initState() {
    super.initState();
    future = context.read<GetBookingsCubit>().getReviewHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reviews yet"));
        }

        final sessions = snapshot.data!;

        return ListView.separated(
          //physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            return HistoryCard(data: sessions[index]);
          },
        );
        ;
=======
import 'package:skill_swap/desktop/presentation/history/models/history_model.dart';

import '../widgets/history_card.dart';

class ReviewSessionsPage extends StatelessWidget {
  const ReviewSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> receivedReviews = [
      HistoryModel(
        id: "1",
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
        id: "1",
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
        id: "1",
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
        id: "1",
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
    return ListView.separated(
      //  physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: receivedReviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: receivedReviews[index]);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      },
    );
  }
}
