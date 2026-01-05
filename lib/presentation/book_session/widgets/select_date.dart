import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/colors.dart';

class SelectDate extends StatefulWidget {
  final Function(DateTime) onSelect;
  const SelectDate({super.key, required this.onSelect});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  DateTime today = DateTime.now();

  void onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      today = day;
    });
    widget.onSelect(day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 288,
      decoration: BoxDecoration(
        color: AppColor.grayColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 32,
        daysOfWeekHeight: 16,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, size: 20),
          rightChevronIcon: Icon(Icons.chevron_right, size: 20),
        ),

        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          weekendStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,

          selectedDecoration: BoxDecoration(
            color: AppColor.mainColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),

          todayDecoration: BoxDecoration(
            color: AppColor.mainColor.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: AppColor.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),

          defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),

          defaultTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          outsideTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),

          cellAlignment: Alignment.center,
          tablePadding: const EdgeInsets.only(top: 4),
        ),

        availableGestures: AvailableGestures.all,
        onDaySelected: onDaySelected,
        selectedDayPredicate: (day) => isSameDay(day, today),
        focusedDay: today,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
      ),
    );
  }
}