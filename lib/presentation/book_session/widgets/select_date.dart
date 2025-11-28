import 'package:flutter/material.dart'
;
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
    return  Container(
      height: 372,
      decoration: BoxDecoration(
        color: AppColor.grayColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 40,
        daysOfWeekHeight: 24,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black87),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black87),
        ),

        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          weekendStyle: TextStyle(
            fontSize: 14,
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
          ),

          todayDecoration: BoxDecoration(
            color: AppColor.mainColor.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: AppColor.mainColor,
            fontWeight: FontWeight.bold,
          ),

          defaultDecoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          weekendDecoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),

          defaultTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          outsideTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),

          cellAlignment: Alignment.center,
          tablePadding: const EdgeInsets.only(top: 8),
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
