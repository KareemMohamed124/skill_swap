import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/submit_review/submit_review_request.dart';
import '../sessions/models/session.dart';

class RateSessionScreen extends StatefulWidget {
  final SessionModel session;

  const RateSessionScreen({super.key, required this.session});

  @override
  State<RateSessionScreen> createState() => _RateSessionScreenState();
}

class _RateSessionScreenState extends State<RateSessionScreen> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  final Set<String> selectedTags = {};

  Widget _buildUserImage(double cardWidth) {
    final image = widget.session.userImage;

    if (image == null || image.isEmpty) return _buildPlaceholder(cardWidth);

    if (image.startsWith("http") || image.startsWith("https")) {
      return Image.network(
        image,
        width: cardWidth * 0.25,
        height: cardWidth * 0.25,
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
          width: cardWidth * 0.25,
          height: cardWidth * 0.25,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
        );
      } catch (e) {
        return _buildPlaceholder(cardWidth);
      }
    }

    return _buildPlaceholder(cardWidth);
  }

  String formatTime12h(DateTime dt) {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.35;

    return BlocListener<SubmitReviewBloc, SubmitReviewState>(
      listener: (context, state) {
        if (state is SubmitReviewSuccessState) {
          Get.offAll(ThankYouScreen());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const ThankYouScreen()),
          // );
        } else if (state is SubmitReviewFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffF5F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            "Rate Your Session",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Session Summary",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ClipOval(child: _buildUserImage(cardWidth)),
                        const SizedBox(width: 12),
                        Text(
                          widget.session.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    iconText(
                      context: context,
                      icon: Icons.access_time,
                      data: formatTime12h(widget.session.dateTime),
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    iconText(
                      context: context,
                      icon: Icons.calendar_today_outlined,
                      data:
                          "${widget.session.dateTime.day}/${widget.session.dateTime.month}/${widget.session.dateTime.year}",
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  children: [
                    const Text(
                      "How would you rate this session?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            size: 32,
                            color: selectedRating > index
                                ? Colors.amber
                                : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Excellent - Outstanding session!",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Additional Comments (Required)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Tell us about your experience...",
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<SubmitReviewBloc, SubmitReviewState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        selectedRating == 0 || state is SubmitReviewLoading
                            ? null
                            : () {
                                final request = SubmitReviewRequest(
                                  rate: selectedRating,
                                  review: commentController.text,
                                );

                                context.read<SubmitReviewBloc>().add(
                                      ConfirmSubmit(
                                          id: widget.session.sessionId,
                                          request: request),
                                    );
                              },
                    child: state is SubmitReviewLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Submit Feedback",
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "Please rate the session before submitting",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconText({
    required BuildContext context,
    required IconData icon,
    required String data,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.045),
        SizedBox(width: screenWidth * 0.015),
        Flexible(child: Text(data)),
      ],
    );
  }

  Widget _buildPlaceholder(double cardWidth) {
    return Container(
      width: cardWidth * 0.25,
      height: cardWidth * 0.25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                "Thank you for your feedback!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Your rating and feedback help us maintain quality mentorship on the platform.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
