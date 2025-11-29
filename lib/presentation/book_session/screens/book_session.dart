import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';
import 'package:skill_swap/constants/strings.dart';
import 'package:skill_swap/presentation/book_session/widgets/duration_selector.dart';
import 'package:skill_swap/presentation/book_session/widgets/session_type.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: const [
              CustomAppBar(title: 'Session Details',)
            ],
          ),
          Positioned(
            top: 96,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Session Type Section
                      const Text(
                        "Session Type",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: AppData.sessionTypes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final type = AppData.sessionTypes[index];
                          return SessionType(
                            sessionType: type.title,
                            title: type.description,
                            isSelected: selectedSessionIndex == index,
                            onTap: () {
                              setState(() {
                                selectedSessionIndex = index;
                                sessionType = type.title;
                              });
                            },
                            icon: type.icon,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Duration Section
                      const Text(
                        "Select Duration",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor
                        ),
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
                      const Text(
                        "Select Date",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor
                        ),
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
                      const Text(
                        "Select Time",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor
                        ),
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
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColor.mainColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Session Details",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),

                              sessionDetails(data: "Mentor:", input: "Dr. Joumana Johnson"),
                              const SizedBox(height: 4,),
                              sessionDetails(
                                data: "Session Type:",
                                input: sessionType ,
                              ),
                              const SizedBox(height: 4,),
                              sessionDetails(
                                data: "Duration:",
                                input: "$selectedDuration min",
                              ),
                              const SizedBox(height: 4,),
                              sessionDetails(
                                data: "Day:",
                                input: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                              ),
                              const SizedBox(height: 4,),
                              sessionDetails(
                                data: "Time:",
                                input: selectedTime ,
                              ),
                              const SizedBox(height: 4,),
                              sessionDetails(
                                data: "Cost:",
                                input: "35\$",
                              ),
                             // const SizedBox(height: 8,),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      CustomButton(text: 'Book Now!', onPressed: () {  },),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable sessionDetails widget
Widget sessionDetails({required String data, required String input}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        data,
        style: const TextStyle(
          fontSize: 12,
          color: AppColor.mainColor,
        ),
      ),
      Text(
        input,
        style: const TextStyle(
          fontSize: 12,
          color: AppColor.mainColor,
        ),
      ),
    ],
  );
}