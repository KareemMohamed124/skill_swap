import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../sign/widgets/custom_button.dart';
import '../widgets/duration_selector.dart';
import '../widgets/select_date.dart';
import '../widgets/select_time.dart';

class BookSession extends StatefulWidget {
  const BookSession({super.key});

  @override
  State<BookSession> createState() => _BookSessionState();
}

class _BookSessionState extends State<BookSession> {
  int selectedSessionIndex = 0;
  String sessionType = AppData.sessionTypes[0].title;
  String selectedTime = "10:00 AM";
  int selectedDuration = 60;
  DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
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

                    const SizedBox(height: 16),

                    // Date Section
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

                    const SizedBox(height: 16),

                    // Time Section
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

                    const SizedBox(height: 16),

                    // Session Details Container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              input: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
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

                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'book_now!',
                      onPressed: () {},
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
  }}

// Reusable sessionDetails widget
Widget sessionDetails({required BuildContext context, required String data, required String input}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        data,
        style:  TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      Text(
        input,
        style:  TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
    ],
  );
}