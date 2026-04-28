import 'package:flutter/material.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

class AvailabilityBottomSheet extends StatefulWidget {
  final List<String> selectedDays;
  final String fromTime;
  final String toTime;
  final String repeatType;
  final bool isEditMode;
  final DateTime startOfWeek;
  final List<String> disabledDays;

  const AvailabilityBottomSheet(
      {super.key,
      required this.selectedDays,
      required this.fromTime,
      required this.toTime,
      required this.repeatType,
      required this.isEditMode,
      required this.startOfWeek,
      required this.disabledDays});

  @override
  State<AvailabilityBottomSheet> createState() =>
      _AvailabilityBottomSheetState();
}

class _AvailabilityBottomSheetState extends State<AvailabilityBottomSheet> {
  late List<String> days;
  late String fromTime;
  late String toTime;
  late String repeat;

  final allDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  final Map<String, int> dayIndex = {
    "Sat": 0,
    "Sun": 1,
    "Mon": 2,
    "Tue": 3,
    "Wed": 4,
    "Thu": 5,
    "Fri": 6,
  };

  @override
  void initState() {
    super.initState();
    days = [...widget.selectedDays];
    fromTime = widget.fromTime;
    toTime = widget.toTime;
    repeat = widget.repeatType;
  }

  int _toMinutes(String timeStr) {
    final lower = timeStr.toLowerCase().trim();
    final hasPeriod = lower.contains('am') || lower.contains('pm');
    if (hasPeriod) {
      final isPm = lower.contains('pm');
      final clean = lower.replaceAll(RegExp(r'[apm\s]'), '');
      final parts = clean.split(':');
      int h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      if (isPm && h != 12) h += 12;
      if (!isPm && h == 12) h = 0;
      return h * 60 + m;
    } else {
      final parts = lower.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }
  }

  bool get isTimeRangeValid {
    final from = _toMinutes(fromTime);
    final to = _toMinutes(toTime);
    if (to <= from) return false;
    if ((to - from) < 30) return false;
    return true;
  }

  bool get canSave => days.isNotEmpty && isTimeRangeValid;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  void toggleDay(String day) {
    setState(() {
      if (widget.isEditMode) {
        if (days.contains(day)) {
          days.remove(day);
        } else {
          days.add(day);
        }
      } else {
        if (days.contains(day)) {
          days.clear();
        } else {
          days = [day];
        }
      }
    });
  }

  TimeOfDay _parseTime(String time) {
    final lower = time.toLowerCase();
    final isPm = lower.contains('pm');

    final parts = lower.replaceAll(RegExp(r'[apm\s]'), '').split(':');
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> pickTime(bool isFrom) async {
    TimeOfDay initial;

    if (isFrom) {
      initial = TimeOfDay.now();
    } else {
      final from = _parseTime(fromTime);
      initial = TimeOfDay(
        hour: (from.hour + 2) % 24,
        minute: from.minute,
      );
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).cardColor,
              dialHandColor: AppPalette.primary,
              dialBackgroundColor: AppPalette.primary.withOpacity(0.1),
              hourMinuteTextColor: AppPalette.primary,
              hourMinuteColor: AppPalette.primary.withOpacity(0.1),
              dayPeriodColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppPalette.primary;
                }
                return Colors.grey.shade200;
              }),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
            ),
            colorScheme: ColorScheme.light(
              primary: AppPalette.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final newTime = picked.format(context);
      setState(() {
        if (isFrom) {
          fromTime = newTime;
        } else {
          toTime = newTime;
        }
      });

      if (!isTimeRangeValid) {
        final from = _toMinutes(fromTime);
        final to = _toMinutes(toTime);
        if (to <= from) {
          _showSnackBar("End time must be later than start time");
        } else {
          _showSnackBar("Time range must be at least 30 minutes");
        }
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
  }

  String getDateForDay(String day) {
    final index = dayIndex[day]!;
    final date = widget.startOfWeek.add(Duration(days: index));
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _convertTo24(String time) {
    final lower = time.toLowerCase();
    final isPm = lower.contains('pm');

    final parts = lower.replaceAll(RegExp(r'[apm\s]'), '').split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    return "${hour.toString().padLeft(2, '0')}:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Your Availability",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "1. Choose days",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allDays.map((day) {
                  final selected = days.contains(day);
                  //  final isDisabled = widget.disabledDays.contains(day);
                  final now = DateTime.now();

                  final index = dayIndex[day]!;
                  final date = widget.startOfWeek.add(Duration(days: index));

                  final today = DateTime(now.year, now.month, now.day);

                  final isPastDay = date.isBefore(today);

                  final isDisabled =
                      widget.disabledDays.contains(day) || isPastDay;

                  final label =
                      "$day (${getDateForDay(day).split('-')[2]}/${getDateForDay(day).split('-')[1]})";

                  return ChoiceChip(
                    label: Text(
                      label,
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey
                            : selected
                                ? Colors.white
                                : Colors.grey[300],
                      ),
                    ),
                    selected: selected,
                    onSelected: isDisabled ? null : (_) => toggleDay(day),
                    selectedColor: AppPalette.primary,
                    backgroundColor: isDisabled
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDisabled
                            ? Colors.grey
                            : selected
                                ? AppPalette.primary
                                : Colors.grey[700]!,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                "2. Time",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              widget.isEditMode
                  ? Row(
                      children: [
                        Icon(
                          Icons.lock,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$fromTime - $toTime (Locked)",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => pickTime(true),
                            child: Text(
                              fromTime,
                              style: TextStyle(color: AppPalette.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => pickTime(false),
                            child: Text(
                              toTime,
                              style: TextStyle(color: AppPalette.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
              if (!widget.isEditMode && !isTimeRangeValid)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _toMinutes(toTime) <= _toMinutes(fromTime)
                        ? "End time must be later than start time"
                        : "Time range must be at least 30 minutes",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              // const SizedBox(height: 20),
              // Text(
              //   "3. Repeat",
              //   style: TextStyle(
              //     color: Theme
              //         .of(context)
              //         .textTheme
              //         .bodyMedium!
              //         .color,
              //   ),
              // ),
              // SizedBox(height: 8,),
              //
              // widget.isEditMode
              //     ? Row(
              //   children: [
              //     Icon(
              //       Icons.lock,
              //       size: 18,
              //       color: Theme
              //           .of(context)
              //           .textTheme
              //           .bodyMedium!
              //           .color,
              //     ),
              //     const SizedBox(width: 6),
              //     Text(
              //       repeat == "weekly" ? "Repeats weekly" : repeat,
              //       style: TextStyle(
              //         color:
              //         Theme
              //             .of(context)
              //             .textTheme
              //             .bodyMedium!
              //             .color,
              //       ),
              //     ),
              //   ],
              // )
              //     : Column(
              //   children: [
              //     RadioListTile(
              //       activeColor: AppPalette.primary,
              //       value: "weekly",
              //       groupValue: repeat,
              //       onChanged: (v) => setState(() => repeat = v!),
              //       title: Text(
              //         "weekly",
              //         style: TextStyle(
              //           color:
              //           Theme
              //               .of(context)
              //               .textTheme
              //               .bodyMedium!
              //               .color,
              //         ),
              //       ),
              //     ),
              //     RadioListTile(
              //       activeColor: AppPalette.primary,
              //       value: "monthly",
              //       groupValue: repeat,
              //       onChanged: (v) => setState(() => repeat = v!),
              //       title: Text(
              //         "Monthly",
              //         style: TextStyle(
              //           color:
              //           Theme
              //               .of(context)
              //               .textTheme
              //               .bodyMedium!
              //               .color,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canSave ? AppPalette.primary : Colors.grey.shade400,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (!canSave) {
                      final from = _toMinutes(fromTime);
                      final to = _toMinutes(toTime);
                      final message = days.isEmpty
                          ? "Please select at least one day"
                          : to <= from
                              ? "End time must be later than start time"
                              : "Time range must be at least 30 minutes";
                      _showSnackBar(message);
                      return;
                    }

                    Navigator.pop(context, {
                      "day": days.first,
                      "from": fromTime,
                      "to": toTime,
                      "repeat": repeat,
                    });
                  },
                  child: const Text(
                    "Save Availability",
                    style: TextStyle(
                      color: Color(0XFFF2F5F8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
