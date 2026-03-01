import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/book_session/book_session_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/booking/booking_request.dart';
import '../../../../shared/data/models/update_booking/update_booking_request.dart';
import '../../sign/widgets/custom_button.dart';
import '../widgets/duration_selector.dart';
import '../widgets/select_date.dart';
import '../widgets/select_time.dart';

class BookSessionDesktop extends StatefulWidget {
  final String userId;
  final String? bookingId;
  final String userName;
  final int price;

  const BookSessionDesktop({
    super.key,
    required this.userId,
    this.bookingId,
    required this.userName,
    required this.price,
  });

  @override
  State<BookSessionDesktop> createState() => _BookSessionDesktopState();
}

class _BookSessionDesktopState extends State<BookSessionDesktop> {
  int selectedDuration = 60;
  String selectedTime = "10:00 AM";
  DateTime selectedDate = DateTime.now();
  String bookingStatus = "";

  String to24Hour(String time12h) {
    try {
      final inputFormat = DateFormat('hh:mm a');
      final outputFormat = DateFormat('HH:mm');
      final dt = inputFormat.parse(time12h);
      return outputFormat.format(dt);
    } catch (_) {
      return time12h;
    }
  }

  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  @override
  void initState() {
    super.initState();
    if (widget.bookingId != null) {
      context
          .read<ActiveBookingBloc>()
          .add(LoadBookingDetails(widget.bookingId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<ActiveBookingBloc, ActiveBookingState>(
      listener: (context, state) {
        if (state is BookingCreatedSuccess) {
          Get.snackbar("Success", "Booking created successfully");
        }
        if (state is BookingError) {
          Get.snackbar("Error", state.message);
        }
        if (state is BookingLoaded) {
          bookingStatus = state.booking.status;
          selectedDate = state.booking.date ?? selectedDate;
          selectedTime = state.booking.time;
          selectedDuration = state.booking.duration_mins;
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingLoading;
        final booking = state is BookingLoaded ? state.booking : null;

        return Scaffold(
          backgroundColor:
              isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Session Details",
                  style: TextStyle(
                    color: Color(0xFFD6D6D6),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Duration Section
                        Text("select_duration".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        DurationSelector(
                          initialValue: selectedDuration,
                          onSelect: (value) =>
                              setState(() => selectedDuration = value),
                        ),
                        const SizedBox(height: 16),

                        // Date Section
                        Text("select_date".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        SelectDate(
                          initialDate: selectedDate,
                          onSelect: (value) =>
                              setState(() => selectedDate = value),
                        ),
                        const SizedBox(height: 16),

                        // Time Section
                        Text("select_time".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        SelectTime(
                          initialTime: selectedTime,
                          onSelect: (value) =>
                              setState(() => selectedTime = value),
                        ),
                        const SizedBox(height: 16),

                        // Session Details Container
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sessionDetails(
                                    context: context,
                                    data: "mentor:".tr,
                                    input: widget.userName),
                                const SizedBox(height: 4),
                                sessionDetails(
                                    context: context,
                                    data: "duration:".tr,
                                    input: "$selectedDuration min"),
                                const SizedBox(height: 4),
                                sessionDetails(
                                  context: context,
                                  data: "day:".tr,
                                  input:
                                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                ),
                                const SizedBox(height: 4),
                                sessionDetails(
                                    context: context,
                                    data: "time:".tr,
                                    input: selectedTime),
                                const SizedBox(height: 4),
                                sessionDetails(
                                  context: context,
                                  data: "cost:".tr,
                                  input: booking?.price != null
                                      ? "${booking!.price}\$"
                                      : "${widget.price}\$",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Action Buttons
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Row(
                            children: [
                              if (booking != null &&
                                  booking.status != "accepted") ...[
                                Expanded(
                                  child: CustomButton(
                                    text: "cancel".tr,
                                    onPressed: () => context
                                        .read<ActiveBookingBloc>()
                                        .add(CancelBooking(booking.id)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomButton(
                                    text: "update".tr,
                                    onPressed: () {
                                      context.read<ActiveBookingBloc>().add(
                                            UpdateBooking(
                                              booking.id.toString(),
                                              UpdateBookingRequest(
                                                date: formatDate(selectedDate),
                                                time: to24Hour(selectedTime),
                                                duration_mins: selectedDuration,
                                                price: booking.price ??
                                                    widget.price,
                                              ),
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: CustomButton(
                                    text: "book_now!".tr,
                                    onPressed: () {
                                      context.read<ActiveBookingBloc>().add(
                                            CreateBooking(
                                              BookingRequest(
                                                date: formatDate(selectedDate),
                                                time: to24Hour(selectedTime),
                                                duration_mins: selectedDuration,
                                                instructorId: widget.userId,
                                                price: widget.price,
                                              ),
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Reusable sessionDetails widget
Widget sessionDetails(
    {required BuildContext context,
    required String data,
    required String input}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(data,
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium!.color)),
      Text(input,
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium!.color)),
    ],
  );
}
