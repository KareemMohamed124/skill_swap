import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../details/models/details_model.dart';
import '../../details/screens/session_details.dart';
import '../models/history_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel data;

  const HistoryCard({super.key, required this.data});

  Color getStatusColor() {
    switch (data.status) {
      case "Finished":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Cancelled":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool get isIssue => data.errorMessage != null;

  bool get isCancelled => data.status == "Cancelled";

  bool get isFinishedRated => data.status == "Finished" && data.rating > 0;

  bool get isFinishedNotRated => data.status == "Finished" && data.rating == 0;

  bool get isReviewReceived => data.isReviewReceived == true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
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
                  data.imageUrl,
                  width: screenWidth * 0.1, // بدل 40
                  height: screenWidth * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(data.role,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (!isReviewReceived)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.005,
                      horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                )
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              Icon(Icons.calendar_month,
                  size: screenWidth * 0.05,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              SizedBox(width: screenWidth * 0.02),
              Text(data.date, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: screenWidth * 0.05,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              SizedBox(width: screenWidth * 0.02),
              Text("${data.time} – ${data.duration}",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          buildBottomSection(context, screenWidth, screenHeight),
        ],
      ),
    );
  }

  Widget buildBottomSection(
      BuildContext context, double screenWidth, double screenHeight) {
    double buttonHeight = screenHeight * 0.06;

    // REVIEW RECEIVED
    if (isReviewReceived) {
      return Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withOpacity(0.16),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Their rating:",
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(width: screenWidth * 0.02),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < data.rating ? Icons.star : Icons.star_border,
                      size: screenWidth * 0.045,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            if (data.reviewComment != null &&
                data.reviewComment!.isNotEmpty) ...[
              SizedBox(height: screenHeight * 0.01),
              Text(
                "“${data.reviewComment}”",
                style: TextStyle(
                  fontSize: screenWidth * 0.033,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // ISSUE
    if (isIssue) {
      return Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFFF9DADA),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Row(
          children: [
            Text("Error: ", style: TextStyle(color: Colors.black)),
            Expanded(
              child: Text(
                data.errorMessage!,
                style: TextStyle(color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // CANCELLED
    if (isCancelled) {
      return Container(
        width: double.infinity,
        height: buttonHeight,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD6D6D6)),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Center(
          child: Text("View Details",
              style: Theme.of(context).textTheme.titleMedium),
        ),
      );
    }

    // FINISHED & RATED
    if (isFinishedRated) {
      return Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withOpacity(0.16),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Row(
          children: [
            Text("Your rating: ",
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < data.rating ? Icons.star : Icons.star_border,
                  size: screenWidth * 0.045,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // FINISHED NOT RATED
    if (isFinishedNotRated) {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: buttonHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD6D6D6)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.035),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border_outlined, size: screenWidth * 0.05),
                    SizedBox(width: screenWidth * 0.01),
                    Text("Rate Session",
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.to(SessionDetailsPage(
                  session: SessionModel(
                    mentorId: data.id,
                    mentorImage: data.imageUrl,
                    mentorName: data.name,
                    mentorTrack: data.role,
                    status: data.status,
                    date: DateTime(2025, 10, 6),
                    time: data.time,
                    duration: data.duration,
                    rating: data.rating,
                    review: 'Great session, learned a lot!',
                    notes: 'Covered Flutter BLoC basics',
                  ),
                ));
              },
              child: Container(
                height: buttonHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD6D6D6)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.035),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined, size: screenWidth * 0.05),
                    SizedBox(width: screenWidth * 0.01),
                    Text("View Details",
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
