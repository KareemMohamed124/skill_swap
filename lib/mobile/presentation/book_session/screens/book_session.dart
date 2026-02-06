import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/constants/strings.dart';
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
    /// ✅ MediaQuery
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;

    return BaseScreen(
        title: "session_details".tr,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
            ),
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
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.04,
                    ),
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
                            color: Theme.of(context).textTheme.bodyLarge!.color,
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
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
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

                CustomButton(
                  text: 'book_now!',
                  onPressed: () {},
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ));
  }
}

/// Reusable sessionDetails widget
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
