import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/book_session/book_session_state.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/booking/booking_request.dart';
import '../../../../shared/data/models/booking_availability/available_dates.dart';
import '../../../../shared/data/models/get_booking/booking.dart';
import '../../../../shared/data/models/update_booking/update_booking_request.dart';

class Booking {
  final DateTime start;
  final DateTime end;
  final String status;

  Booking({
    required this.start,
    required this.end,
    required this.status,
  });
}

class BookingBottomSheet extends StatefulWidget {
  final String userId;
  final String userName;
  final int price;
  final String? bookingId;
  final List<AvailableDates> availableDates;

  const BookingBottomSheet({
    super.key,
    required this.userId,
    required this.userName,
    required this.price,
    this.bookingId,
    required this.availableDates,
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final List<String> durations = ['30', '45', '60', '90', '120'];
  String selectedDuration = '45';

  String? selectedDate;
  DateTime? startTime;

  List<Booking> apiBookings = [];

  AvailableDates? get selectedDayData {
    if (selectedDate == null) return null;
    try {
      return widget.availableDates.firstWhere((e) => e.date == selectedDate);
    } catch (_) {
      return null;
    }
  }

  late GetBookingsCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = context.read<GetBookingsCubit>();

    _loadBookings();

    if (widget.bookingId != null) {
      context
          .read<ActiveBookingBloc>()
          .add(LoadBookingDetails(widget.bookingId!));
    }
  }

  Future<void> _loadBookings() async {
    final List<GetBookingModel> bookings =
        await cubit.fetchAcceptedBookingsRaw();

    apiBookings = bookings
        .where((b) =>
            b.instructorId.id == widget.userId &&
            b.status == "accepted") // ✅ مهم
        .map((b) {
      final baseDate = b.date.toLocal();

      final timeParts = b.time.split(":");

      final dateTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      return Booking(
        start: dateTime,
        end: dateTime.add(Duration(minutes: b.durationMins)),
        status: b.status,
      );
    }).toList();

    print("=== apiBookings count: ${apiBookings.length} ===");

    setState(() {});
  }

  int get durationMinutes => int.parse(selectedDuration);

  DateTime? get endTime => startTime?.add(Duration(minutes: durationMinutes));

  String formatDay(String date) {
    final d = DateTime.parse(date);
    return DateFormat('EEE dd MMM').format(d);
  }

  List<DateTime> generateSlots() {
    if (selectedDayData == null) return [];

    final List<DateTime> slots = [];

    final date = DateTime.parse(selectedDayData!.date);

    final fromParts = selectedDayData!.from.split(":");
    final toParts = selectedDayData!.to.split(":");

    DateTime start = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(fromParts[0]),
      int.parse(fromParts[1]),
    );

    DateTime end = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(toParts[0]),
      int.parse(toParts[1]),
    );

    while (start.isBefore(end)) {
      slots.add(start);
      start = start.add(const Duration(minutes: 15));
    }

    return slots;
  }

  bool canSelectSlot(DateTime slotStart) {
    final slotEnd = slotStart.add(Duration(minutes: durationMinutes));

    return !apiBookings.any((booking) {
      if (booking.status != "accepted") return false;

      final bookingStart = booking.start;
      final bookingEnd = booking.end; // ✅ استخدميها مباشرة

      final overlaps =
          slotStart.isBefore(bookingEnd) && slotEnd.isAfter(bookingStart);

      return overlaps;
    });
  }

  bool isInSelectedRange(DateTime slot) {
    if (startTime == null || endTime == null) return false;

    return slot.isAfter(startTime!.subtract(const Duration(minutes: 1))) &&
        slot.isBefore(endTime!);
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  String to24Hour(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  bool isDayFullyBooked(AvailableDates day) {
    final date = DateTime.parse(day.date);

    final fromParts = day.from.split(":");
    final toParts = day.to.split(":");

    DateTime start = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(fromParts[0]),
      int.parse(fromParts[1]),
    );

    DateTime end = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(toParts[0]),
      int.parse(toParts[1]),
    );

    while (start.isBefore(end)) {
      final slotEnd = start.add(Duration(minutes: durationMinutes));

      final isSlotAvailable = apiBookings.any((booking) {
        if (booking.status != "accepted") return false;

        final sameDay = booking.start.year == date.year &&
            booking.start.month == date.month &&
            booking.start.day == date.day;

        if (!sameDay) return false;

        final overlaps =
            start.isBefore(booking.end) && slotEnd.isAfter(booking.start);

        return overlaps;
      });

      // لو لقينا slot مش متعارض → اليوم مش full
      if (!isSlotAvailable) {
        return false;
      }

      start = start.add(const Duration(minutes: 15));
    }

    // كل السلوات متعارضة → اليوم full
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final slots = generateSlots();

    return BlocConsumer<ActiveBookingBloc, ActiveBookingState>(
      listener: (context, state) {
        if (state is BookingCreatedSuccess) {
          Get.snackbar("Success", "Booking created successfully");
        }

        if (state is BookingError) {
          Get.snackbar("Error", state.message);
        }

        if (state is BookingLoaded) {
          selectedDate = DateFormat('yyyy-MM-dd').format(state.booking.date!);

          startTime = DateTime(
            state.booking.date!.year,
            state.booking.date!.month,
            state.booking.date!.day,
            int.parse(state.booking.time.split(":")[0]),
            int.parse(state.booking.time.split(":")[1]),
          );

          selectedDuration = state.booking.duration_mins.toString();
        }

        setState(() {});
      },
      builder: (context, state) {
        final isLoading = state is BookingLoading;
        final booking = state is BookingLoaded ? state.booking : null;

        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text("select_date".tr,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: widget.availableDates.map((day) {
                  final isSelected = selectedDate == day.date;
                  final isDisabled = isDayFullyBooked(day);

                  return ChoiceChip(
                    label: Text(formatDay(day.date)),
                    selected: isSelected,
                    onSelected: isDisabled
                        ? null
                        : (_) {
                            setState(() {
                              selectedDate = day.date;
                              startTime = null;
                            });
                          },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text("select_duration".tr,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: durations.length,
                  itemBuilder: (_, index) {
                    final d = durations[index];
                    final selected = selectedDuration == d;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text("$d min"),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            selectedDuration = d;
                            startTime = null;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text("select_time".tr,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              if (selectedDate == null)
                const Text("Select a day first")
              else
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: slots.length,
                    itemBuilder: (_, index) {
                      final slot = slots[index];

                      final disabled = !canSelectSlot(slot);
                      final inRange = isInSelectedRange(slot);

                      return GestureDetector(
                        onTap: disabled
                            ? null
                            : () {
                                setState(() {
                                  startTime = slot;
                                });
                              },
                        child: Container(
                          width: 75,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: disabled
                                ? Colors.grey.shade800
                                : inRange
                                    ? AppPalette.primary
                                    : Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            formatTime(slot),
                            style: TextStyle(
                              color: disabled ? Colors.grey : Colors.white,
                              fontWeight:
                                  inRange ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const Spacer(),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (booking != null && booking.status != "accepted")
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<ActiveBookingBloc>()
                              .add(CancelBooking(booking.id));
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final request = UpdateBookingRequest(
                            date: selectedDate!,
                            time: to24Hour(startTime!),
                            duration_mins: durationMinutes,
                            price: booking.price ?? widget.price,
                          );

                          context.read<ActiveBookingBloc>().add(
                              UpdateBooking(booking.id.toString(), request));
                        },
                        child: const Text("Update"),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: startTime == null || selectedDate == null
                        ? null
                        : () {
                            final request = BookingRequest(
                              date: selectedDate!,
                              time: to24Hour(startTime!),
                              duration_mins: durationMinutes,
                              instructorId: widget.userId,
                              price: widget.price,
                            );

                            context
                                .read<ActiveBookingBloc>()
                                .add(CreateBooking(request));
                          },
                    child: const Text("Confirm Booking"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
