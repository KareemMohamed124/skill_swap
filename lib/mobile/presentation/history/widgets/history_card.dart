<<<<<<< HEAD
import 'dart:convert';

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../details/models/details_model.dart';
import '../../details/screens/session_details.dart';
import '../models/history_model.dart';

<<<<<<< HEAD
class HistoryCard extends StatefulWidget {
=======
class HistoryCard extends StatelessWidget {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final HistoryModel data;

  const HistoryCard({super.key, required this.data});

<<<<<<< HEAD
  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  Color getStatusColor() {
    switch (widget.data.status) {
=======
  Color getStatusColor() {
    switch (data.status) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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

<<<<<<< HEAD
  bool get isIssue => widget.data.errorMessage != null;

  bool get isCancelled => widget.data.status == "Cancelled";

  bool get isFinished => widget.data.status == "Finished";

  bool get isReviewReceived => widget.data.isReviewReceived == true;

  Widget _buildPlaceholder(double cardWidth) {
    return Container(
      width: cardWidth,
      height: cardWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildUserImage(double cardWidth) {
    final image = widget.data.imageUrl;

    if (image == null || image.isEmpty) {
      return _buildPlaceholder(cardWidth);
    }

    if (image.startsWith("http") || image.startsWith("https")) {
      return Image.network(
        image,
        width: cardWidth,
        height: cardWidth,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
      );
    }

    if (image.startsWith("data:image")) {
      try {
        final base64Str = image.split(',')[1];
        final bytes = base64Decode(base64Str);

        return Image.memory(
          bytes,
          width: cardWidth,
          height: cardWidth,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
        );
      } catch (e) {
        return _buildPlaceholder(cardWidth);
      }
    }

    return _buildPlaceholder(cardWidth);
  }
=======
  bool get isIssue => data.errorMessage != null;

  bool get isCancelled => data.status == "Cancelled";

  bool get isFinishedRated => data.status == "Finished" && data.rating > 0;

  bool get isFinishedNotRated => data.status == "Finished" && data.rating == 0;

  bool get isReviewReceived => data.isReviewReceived == true;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

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
<<<<<<< HEAD
              ClipOval(child: _buildUserImage(screenWidth * 0.1)),
=======
              ClipOval(
                child: Image.asset(
                  data.imageUrl,
                  width: screenWidth * 0.1, // بدل 40
                  height: screenWidth * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(widget.data.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(widget.data.role,
=======
                    Text(data.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(data.role,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                    widget.data.status,
=======
                    data.status,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
              Text(widget.data.date,
                  style: Theme.of(context).textTheme.bodyMedium),
=======
              Text(data.date, style: Theme.of(context).textTheme.bodyMedium),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: screenWidth * 0.05,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              SizedBox(width: screenWidth * 0.02),
<<<<<<< HEAD
              Text("${widget.data.time} – ${widget.data.duration}",
=======
              Text("${data.time} – ${data.duration}",
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                      i < widget.data.rating ? Icons.star : Icons.star_border,
=======
                      i < data.rating ? Icons.star : Icons.star_border,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      size: screenWidth * 0.045,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
            if (widget.data.reviewComment != null &&
                widget.data.reviewComment!.isNotEmpty) ...[
              SizedBox(height: screenHeight * 0.01),
              Text(
                "“${widget.data.reviewComment}”",
=======
            if (data.reviewComment != null &&
                data.reviewComment!.isNotEmpty) ...[
              SizedBox(height: screenHeight * 0.01),
              Text(
                "“${data.reviewComment}”",
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                widget.data.errorMessage!,
=======
                data.errorMessage!,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
    if (isFinished) {
=======
    if (isFinishedRated) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                  i < widget.data.rating ? Icons.star : Icons.star_border,
=======
                  i < data.rating ? Icons.star : Icons.star_border,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
    if (isFinished) {
=======
    if (isFinishedNotRated) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                      mentorId: widget.data.id,
                      mentorImage: widget.data.imageUrl,
                      mentorName: widget.data.name,
                      mentorTrack: widget.data.role,
                      status: widget.data.status,
                      date: DateTime(2025, 10, 6),
                      time: widget.data.time,
                      duration: widget.data.duration,
                      rating: widget.data.rating,
=======
                      mentorId: data.id,
                      mentorImage: data.imageUrl,
                      mentorName: data.name,
                      mentorTrack: data.role,
                      status: data.status,
                      date: DateTime(2025, 10, 6),
                      time: data.time,
                      duration: data.duration,
                      rating: data.rating,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      review: 'Great session, learned a lot!',
                      notes: 'Covered Flutter BLoC basics',
                      bio: "",
                      skills: []),
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
