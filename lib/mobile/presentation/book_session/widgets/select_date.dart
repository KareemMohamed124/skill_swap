import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../shared/core/theme/app_palette.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final containerHeight = screenHeight * 0.35; // ارتفاع نسبي
    final rowHeight = screenHeight * 0.04;
    final daysOfWeekHeight = screenHeight * 0.02;

    final headerFontSize = screenWidth * 0.045;
    final weekdayFontSize = screenWidth * 0.035;
    final todayFontSize = screenWidth * 0.035;
    final defaultFontSize = screenWidth * 0.035;

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: rowHeight,
        daysOfWeekHeight: daysOfWeekHeight,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: headerFontSize,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, size: screenWidth * 0.05),
          rightChevronIcon: Icon(Icons.chevron_right, size: screenWidth * 0.05),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: weekdayFontSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          weekendStyle: TextStyle(
            fontSize: weekdayFontSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            color: AppPalette.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
            fontSize: defaultFontSize,
          ),
          todayDecoration: BoxDecoration(
            color: AppPalette.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: AppPalette.primary,
            fontWeight: FontWeight.bold,
            fontSize: todayFontSize,
          ),
          defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          defaultTextStyle: TextStyle(
            color: Colors.black,
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w500,
          ),
          weekendTextStyle: TextStyle(
            color: Colors.black,
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w500,
          ),
          outsideTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: defaultFontSize * 0.9,
            fontWeight: FontWeight.w500,
          ),
          cellAlignment: Alignment.center,
          tablePadding: EdgeInsets.only(top: screenHeight * 0.005),
        ),
        availableGestures: AvailableGestures.all,
        onDaySelected: onDaySelected,
        selectedDayPredicate: (day) => isSameDay(day, today),
        focusedDay: today,
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 3, 14),
      ),
    );
  }
}
