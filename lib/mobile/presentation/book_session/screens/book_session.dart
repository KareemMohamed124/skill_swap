import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/book_session/book_session_state.dart';
import '../../../../shared/common_ui/base_screen.dart';
import '../../../../shared/data/models/booking/booking_request.dart';
import '../../../../shared/data/models/update_booking/update_booking_request.dart';
import '../../sign/widgets/custom_button.dart';
import '../widgets/duration_selector.dart';
import '../widgets/select_date.dart';
import '../widgets/select_time.dart';

class BookSessionScreen extends StatefulWidget {
  final String userId;
  final String? bookingId;
  final String userName;
  final int price;

  const BookSessionScreen(
      {super.key,
      required this.userId,
      this.bookingId,
      required this.userName,
      required this.price});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  String selectedTime = "10:00 AM";
  int selectedDuration = 60;
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

  String to12Hour(String time24h) {
    try {
      final inputFormat = DateFormat('HH:mm');
      final outputFormat = DateFormat('hh:mm a');
      final dt = inputFormat.parse(time24h);
      return outputFormat.format(dt);
    } catch (_) {
      return time24h;
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
          selectedTime = to12Hour(state.booking.time);
          selectedDuration = state.booking.duration_mins;
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingLoading;
        final booking = state is BookingLoaded ? state.booking : null;

        return BaseScreen(
          title: "session_details".tr,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Duration
                  Text("select_duration".tr,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  DurationSelector(
                    initialValue: selectedDuration,
                    onSelect: (v) => setState(() => selectedDuration = v),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  /// Date
                  Text("select_date".tr,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  SelectDate(
                    initialDate: selectedDate,
                    onSelect: (v) => setState(() => selectedDate = v),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  /// Time
                  Text("select_time".tr,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  SelectTime(
                    initialTime: selectedTime,
                    onSelect: (v) => setState(() => selectedTime = v),
                  ),
                  SizedBox(height: screenHeight * 0.03),

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
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          sessionDetails(
                            context: context,
                            data: "mentor:".tr,
                            input: widget.userName,
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
                            input: booking?.price != null
                                ? "${booking!.price}\$"
                                : "${widget.price}\$",
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  /// Action Buttons
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildActionButtons(context, booking),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic booking) {
    final bloc = context.read<ActiveBookingBloc>();

    if (booking != null && booking.status != "accepted") {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "cancel".tr,
              onPressed: () => bloc.add(CancelBooking(booking.id)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: "update".tr,
              onPressed: () {
                final request = UpdateBookingRequest(
                  date: formatDate(selectedDate),
                  time: to24Hour(selectedTime),
                  duration_mins: selectedDuration,
                  price: booking.price ?? 100,
                );
                bloc.add(UpdateBooking(booking.id.toString(), request));
              },
            ),
          ),
        ],
      );
    }

    return CustomButton(
      text: "book_now!".tr,
      onPressed: () {
        final request = BookingRequest(
          date: formatDate(selectedDate),
          time: to24Hour(selectedTime),
          duration_mins: selectedDuration,
          instructorId: widget.userId.toString(),
          price: widget.price,
        );

        bloc.add(CreateBooking(request));
      },
    );
  }
}

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
