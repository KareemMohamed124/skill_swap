import 'package:flutter/material.dart';
import 'package:skill_swap/main.dart';
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
  bool get isFinishedNotRated =>
      data.status == "Finished" && data.rating == 0;
  bool get isReviewReceived => data.isReviewReceived == true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  data.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: Theme.of(context).textTheme.titleMedium
                    ),
                    Text(
                      data.role,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              if (!isReviewReceived)
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: getStatusColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.calendar_month, size: 20, color: Theme.of(context).textTheme.bodyMedium!.color,),
              const SizedBox(width: 8),
              Text(data.date, style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: Theme.of(context).textTheme.bodyMedium!.color),
              const SizedBox(width: 8),
              Text("${data.time} – ${data.duration}", style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),

          const SizedBox(height: 16),

          buildBottomSection(context),
        ],
      ),
    );
  }

  Widget buildBottomSection(BuildContext context) {

    // REVIEW RECEIVED
    if (isReviewReceived) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                 Text(
                  "Their rating:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
                        (i) => Icon(
                      i < data.rating ? Icons.star : Icons.star_border,
                      size: 18,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            if (data.reviewComment != null &&
                data.reviewComment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "“${data.reviewComment}”",
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      );
    }

    //  ISSUE
    if (isIssue) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF9DADA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
             Text(
              "Error: ",
               style: TextStyle(color: Colors.black),
            ),
            Text(
              data.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    //  CANCELLED
    if (isCancelled) {
      return Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD6D6D6)),
          borderRadius: BorderRadius.circular(14),
        ),
        child:  Center(
          child: Text(
            "View Details",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    //  FINISHED & RATED
    if (isFinishedRated) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Text(
              "Your rating: ",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < data.rating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      );
    }

    //  FINISHED NOT RATED
    if (isFinishedNotRated) {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD6D6D6)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border_outlined),
                    SizedBox(width: 4),
                    Text("Rate Session", style: Theme.of(context).textTheme.titleMedium,),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
               desktopKey.currentState?.openSidePage(body: SessionDetailsPage(
                 session: SessionModel(
                     mentorId: data.id,
                     mentorImage: data.imageUrl,
                     mentorName: data.name,
                     mentorTrack: data.role,
                     status: data.status,
                     date: DateTime(2025,10,6),
                     time: data.time,
                     duration: data.duration,
                     rating: data.rating,
                     review: 'Great session, learned a lot!',
                     notes: 'Covered Flutter BLoC basics'

                 ),));
                // Get.to(SessionDetailsPage(
                //   session: SessionModel(
                //     mentorId: data.id,
                //     mentorImage: data.imageUrl,
                //     mentorName: data.name,
                //     mentorTrack: data.role,
                //     status: data.status,
                //     date: DateTime(2025,10,6),
                //     time: data.time,
                //     duration: data.duration,
                //     rating: data.rating,
                //     review: 'Great session, learned a lot!',
                //     notes: 'Covered Flutter BLoC basics'
                //
                //   ),));
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD6D6D6)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined),
                    SizedBox(width: 4),
                    Text("View Details", style: Theme.of(context).textTheme.titleMedium,),
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