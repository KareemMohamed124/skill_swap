import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/constants/colors.dart';
import 'package:skill_swap/presentation/book_session/screens/book_session.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';
import '../../profile/pages/reviews_page.dart';
import '../widgets/profile_mentor_header.dart';

class ProfileMentor extends StatefulWidget {
  final String image;
  final String name;
  final String track;
  final String rate;

  const ProfileMentor({
    super.key,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
  });

  @override
  State<ProfileMentor> createState() => _ProfileMentorState();
}

class _ProfileMentorState extends State<ProfileMentor> {
  final List<String> skills = [
    "Node.js", "Html","JavaScript","TypeScript",
    "Responsive Design", "React","Css",
    "Testing", "Web Services API", "C++",
  ];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ProfileMentorHeader(
                image: widget.image,
                name: widget.name,
                track: widget.track,
                rate: widget.rate,
              ),
            ],
          ),

          Positioned(
            top: 188,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            mentorInfo(
                              rate: "200",
                              info: "Hours Available",
                            ),
                            mentorInfo(
                              rate: "150",
                              info: "People Helped",
                            ),
                            mentorInfo(
                              rate: "35\$",
                              info: "Hourly Rate",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// About Title
                      const Text(
                        "About",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Front-End Developer specializing in building responsive, user-friendly, and accessible web applications. Skilled in React, JavaScript, and modern UI frameworks.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.75,
                          color: AppColor.mainColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Skills",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.grayColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),
                      ReviewsPage(),

                      const SizedBox(height: 16),

                      CustomButton(
                        text: "Session details",
                        onPressed: () {
                          Get.to(const BookSession());
                        },
                      ),
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


Widget mentorInfo({required String rate, required String info}) {
  return  Column(
    children: [
      Text(
        rate,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.mainColor),
      ),
      SizedBox(height: 4),
      Text(
        info,
        style: TextStyle(fontSize: 12, color: AppColor.mainColor),
      ),
    ],
  );
}