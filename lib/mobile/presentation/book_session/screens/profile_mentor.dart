import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../profile/pages/reviews_page.dart';
import '../../prv_chat/private_chat_screen.dart';
import '../../sign/widgets/custom_button.dart';
import '../widgets/profile_mentor_header.dart';
import 'book_session.dart';

class ProfileMentor extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String track;
  final int rate;

  const ProfileMentor({
    super.key,
    required this.id,
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
    "Node.js",
    "Html",
    "JavaScript",
    "TypeScript",
    "Responsive Design",
    "React",
    "Css",
    "Testing",
    "Web Services API",
    "C++",
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // =========================================
    // CircleAvatar helper function
    Widget buildAvatar(String? avatarPath) {
      final hasImage = avatarPath != null && avatarPath.isNotEmpty;

      return CircleAvatar(
        radius: screenWidth * 0.12,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:
            (hasImage && defaultTargetPlatform != TargetPlatform.windows)
                ? FileImage(File(avatarPath))
                : null,
        child: (!hasImage || defaultTargetPlatform == TargetPlatform.windows)
            ? Icon(
                Icons.person,
                size: screenWidth * 0.12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              )
            : null,
      );
    }
    // =========================================

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ProfileMentorHeader(
                  id: widget.id,
                  image: widget.image,
                  name: widget.name,
                  track: widget.track,
                  rate: widget.rate,
                ),
              ],
            ),
            Positioned(
              top: screenHeight * 0.16,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: screenHeight),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.08),
                    topRight: Radius.circular(screenWidth * 0.08),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Mentor Info (Hours, People Helped, Rate)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.08),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              mentorInfo(
                                  context: context,
                                  rate: "200",
                                  info: "hours_available".tr),
                              mentorInfo(
                                  context: context,
                                  rate: "150",
                                  info: "people_helped".tr),
                              mentorInfo(
                                  context: context,
                                  rate: "35\$",
                                  info: "hourly_rate".tr),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        /// About
                        Text("about".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text(
                          "Front-End Developer specializing in building responsive, user-friendly, and accessible web applications. Skilled in React, JavaScript, and modern UI frameworks.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.75,
                            color: isDark
                                ? AppPalette.darkTextSecondary
                                : AppPalette.lightTextSecondary,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        /// Skills
                        Text("skills".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: skills.map((skill) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFD6D6D6).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        /// Reviews
                        Text("reviews".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        ReviewsPage()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: Row(
          children: [
            Container(
              height: screenHeight * 0.065,
              width: screenHeight * 0.065,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                border: Border.all(color: AppPalette.primary),
              ),
              child: IconButton(
                icon: Icon(Iconsax.message, color: AppPalette.primary),
                onPressed: () {
                  Get.to(
                    PrivateChatScreen(
                      currentUserId: '01',
                      otherUserId: widget.id,
                      otherUserName: widget.name,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                text: "session_details".tr,
                onPressed: () {
                  Get.to(BookSessionScreen(
                    userId: widget.id,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget mentorInfo(
    {required BuildContext context,
    required String rate,
    required String info}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    children: [
      Text(
        rate,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppPalette.primary,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        info,
        style: TextStyle(
            fontSize: 12, color: isDark ? Colors.white : AppPalette.primary),
      ),
    ],
  );
}
