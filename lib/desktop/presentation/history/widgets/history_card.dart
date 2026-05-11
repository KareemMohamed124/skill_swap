import 'package:flutter/material.dart';
import 'package:skill_swap/main.dart';
<<<<<<< HEAD

import '../../../../mobile/presentation/history/models/history_model.dart';
import '../../details/models/details_model.dart';
import '../../details/screens/session_details.dart';
=======
import '../../details/models/details_model.dart';
import '../../details/screens/session_details.dart';
import '../models/history_model.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

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
<<<<<<< HEAD

  bool get isCancelled => data.status == "Cancelled";

  bool get isFinishedRated => data.status == "Finished" && data.rating > 0;

  bool get isFinishedNotRated => data.status == "Finished" && data.rating == 0;

=======
  bool get isCancelled => data.status == "Cancelled";
  bool get isFinishedRated => data.status == "Finished" && data.rating > 0;
  bool get isFinishedNotRated =>
      data.status == "Finished" && data.rating == 0;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
=======

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(data.name,
                        style: Theme.of(context).textTheme.titleMedium),
=======
                    Text(
                      data.name,
                      style: Theme.of(context).textTheme.titleMedium
                    ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    Text(
                      data.role,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD
              if (!isReviewReceived)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
=======

              if (!isReviewReceived)
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 20,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              const SizedBox(width: 8),
              Text(
                data.date,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: 20,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              const SizedBox(width: 8),
              Text(
                "${data.time} – ${data.duration}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
=======

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

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          buildBottomSection(context),
        ],
      ),
    );
  }

  Widget buildBottomSection(BuildContext context) {
<<<<<<< HEAD
=======

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                Text(
=======
                 Text(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  "Their rating:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
<<<<<<< HEAD
                    (i) => Icon(
=======
                        (i) => Icon(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
            Text(
              "Error: ",
              style: TextStyle(color: Colors.black),
=======
             Text(
              "Error: ",
               style: TextStyle(color: Colors.black),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
        child: Center(
=======
        child:  Center(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                (i) => Icon(
=======
                    (i) => Icon(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                child: Row(
=======
                child:  Row(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border_outlined),
                    SizedBox(width: 4),
<<<<<<< HEAD
                    Text(
                      "Rate Session",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
=======
                    Text("Rate Session", style: Theme.of(context).textTheme.titleMedium,),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
<<<<<<< HEAD
                desktopKey.currentState?.openSidePage(
                    body: SessionDetailsPage(
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
                      notes: 'Covered Flutter BLoC basics'),
                ));
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                child: Row(
=======
                child:  Row(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined),
                    SizedBox(width: 4),
<<<<<<< HEAD
                    Text(
                      "View Details",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
=======
                    Text("View Details", style: Theme.of(context).textTheme.titleMedium,),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
