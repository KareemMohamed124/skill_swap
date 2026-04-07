import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/delete_available_dates/delete_available_dates_bloc.dart';
import '../../../../shared/bloc/get_available_dates_bloc/get_available_dates_bloc.dart';

class ManageAvailabilityBottomSheet extends StatefulWidget {
  final List availableDates;
  final VoidCallback onAddPressed;

  const ManageAvailabilityBottomSheet({
    super.key,
    required this.availableDates,
    required this.onAddPressed,
  });

  @override
  State<ManageAvailabilityBottomSheet> createState() =>
      _ManageAvailabilityBottomSheetState();
}

class _ManageAvailabilityBottomSheetState
    extends State<ManageAvailabilityBottomSheet> {
  late List localDates;

  @override
  void initState() {
    super.initState();
    localDates = List.from(widget.availableDates);
  }

  String _getDayName(int weekday) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }

  String _formatTime(String time) {
    final parts = time.split(":");
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final isPm = hour >= 12;
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    final period = isPm ? "PM" : "AM";

    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAvailableDatesBloc, DeleteAvailableDatesState>(
      listener: (context, state) {
        if (state is DeleteAvailableDatesSuccess) {
          Get.snackbar(
            "Success",
            "Deleted successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white.withOpacity(0.2),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 16,
            duration: const Duration(seconds: 2),
          );
        }

        if (state is DeleteAvailableDatesFailure) {
          Get.snackbar(
            "Error",
            state.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white.withOpacity(0.2),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 16,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Days",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<GetAvailableDatesBloc, GetAvailableDatesState>(
              builder: (context, state) {
                List availableDates = [];

                if (state is GetAvailableDatesSuccess) {
                  availableDates = state.data.availableDates;
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...localDates.map((item) {
                      final date = DateTime.parse(item.date);

                      return Chip(
                          label: Text(
                            "${_getDayName(date.weekday)} ${date.day}/${date.month} "
                            "(${_formatTime(item.from)} - ${_formatTime(item.to)})",
                          ),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              localDates.remove(item);
                            });

                            context.read<DeleteAvailableDatesBloc>().add(
                                  DeleteAvailableDates(idOrDate: item.date),
                                );
                          });
                    }).toList(),
                    ActionChip(
                      avatar: const Icon(Icons.add),
                      label: const Text("Add Day"),
                      onPressed: widget.onAddPressed,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
