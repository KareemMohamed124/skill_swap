import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/common_ui/base_screen.dart';
import '../../../../shared/data/models/booking/booking_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/widgets/custom_button.dart';
import '../widgets/duration_selector.dart';
import '../widgets/select_date.dart';
import '../widgets/select_time.dart';

class BookSessionScreen extends StatefulWidget {
  final String userId;

  const BookSessionScreen({super.key, required this.userId});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  String selectedTime = "10:00 AM";
  int selectedDuration = 60;
  DateTime selectedDate = DateTime.now();

  /// 🔥 تحويل 12h → 24h
  String convertTo24Hour(String time12h) {
    final inputFormat = DateFormat('hh:mm a');
    final outputFormat = DateFormat('HH:mm');
    final dateTime = inputFormat.parse(time12h);
    return outputFormat.format(dateTime);
  }

  /// 🔥 فورمات تاريخ نظيف للسيرفر
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;

    return BlocProvider(
      create: (_) => sl<BookSessionBloc>(),
      child: BlocConsumer<BookSessionBloc, BookSessionState>(
        listener: (context, state) {
          if (state is BookSessionSuccess) {
            Get.snackbar('Success', state.success.data.message);
          } else if (state is BookSessionFailure) {
            Get.snackbar('Error', state.error.error.message);
          }
        },
        builder: (context, state) {
          bool isLoading = state is BookSessionLoading;

          return BaseScreen(
            title: "session_details".tr,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    /// Duration
                    Text(
                      "select_duration".tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    DurationSelector(
                      onSelect: (value) {
                        setState(() {
                          selectedDuration = value;
                        });
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    /// Date
                    Text(
                      "select_date".tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    SelectDate(
                      onSelect: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    /// Time
                    Text(
                      "select_time".tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    SelectTime(
                      onSelect: (value) {
                        setState(() {
                          selectedTime = value;
                        });
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    /// Session Details
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "session_details".tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            sessionDetails(
                              context: context,
                              data: "mentor:".tr,
                              input: "Dr. Joumana Johnson",
                            ),
                            const SizedBox(height: 4),
                            sessionDetails(
                              context: context,
                              data: "duration:".tr,
                              input: "$selectedDuration min",
                            ),
                            const SizedBox(height: 4),
                            sessionDetails(
                              context: context,
                              data: "day:".tr,
                              input:
                                  DateFormat('dd/MM/yyyy').format(selectedDate),
                            ),
                            const SizedBox(height: 4),
                            sessionDetails(
                              context: context,
                              data: "time:".tr,
                              input: selectedTime,
                            ),
                            const SizedBox(height: 4),
                            sessionDetails(
                              context: context,
                              data: "cost:".tr,
                              input: "35\$",
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    /// Book Button
                    CustomButton(
                      text: isLoading ? 'booking'.tr : 'book_now!'.tr,
                      onPressed: isLoading
                          ? null
                          : () {
                              final request = BookingRequest(
                                date: formatDate(selectedDate),
                                time: convertTo24Hour(selectedTime),
                                duration_mins: selectedDuration,
                                userId: widget.userId,
                                price: 100,
                              );

                              context
                                  .read<BookSessionBloc>()
                                  .add(BookSession(request: request));
                            },
                    ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Widget لعرض التفاصيل
Widget sessionDetails({
  required BuildContext context,
  required String data,
  required String input,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        data,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      Text(
        input,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
    ],
  );
}
