import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/common_ui/custom_bottom_nav.dart';
import 'package:skill_swap/constants/strings.dart';
import 'package:skill_swap/data/models/user/user_model.dart';
import 'package:skill_swap/presentation/home/widgets/custom_header.dart';
import 'package:skill_swap/presentation/notification/screens/notification_screen.dart';
import '../../../constants/colors.dart';
import '../../../dependency_injection/injection.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../helper/local_storage.dart';
import '../pages/next_session_view_all.dart';
import '../pages/recommended_view_all.dart';
import '../pages/top_users_view_all.dart';
import '../widgets/next_session_card.dart';
import '../widgets/recommended_card.dart';
import '../widgets/section_header.dart';
import '../widgets/top_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  UserModel? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final fetchedUser = await LocalStorage.getUser();
    setState(() {
      user = fetchedUser;
      loading = false;
    });
  }

      @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
     if(loading || user == null) {
       return const Scaffold(
         body: Center(child: CircularProgressIndicator(),),
       );
     }
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomHeader(
                name: 'Hi, ${user!.name ?? ""}',
                subtitle: 'Keep learning and earning hours today!',
                avatarPath: user!.imagePath,
                onIcon1: () {},
                onIcon2: () {Get.to(NotificationsScreen());},
              ),
            ],
          ),
          Positioned(
            top: 132,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Top Users Section
                      SectionHeader(sectionTitle: 'Top Users', onTop: () { Get.to(TopUsersViewAll()); },),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 124,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppData.topUsers.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final user = AppData.topUsers[index];
                            return TopUserCard(
                              id: user.id,
                              image: user.image,
                              name: user.name,
                              track: user.track,
                              hours: user.hours,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Your Next Session Section
                      SectionHeader(sectionTitle: 'Your Next Session', onTop: () { Get.to(NextSessionViewAll()); },),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: AppData.nextSessions.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final session = AppData.nextSessions[index];
                          return NextSessionCard(
                            name: session.name,
                            duration: session.duration,
                            dateTime: session.dateTime,
                            startsIn: session.startsIn,
                            isMentor: session.isMentor,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Recommended Section
                      SectionHeader(sectionTitle: 'Recommended for You', onTop: () {Get.to(RecommendedViewAll());  },),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 178,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppData.recommendedMentors.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final mentor = AppData.recommendedMentors[index];
                            return RecommendedCard(
                              id: mentor.id,
                              image: mentor.image,
                              name: mentor.name,
                              track: mentor.track,
                              rating: mentor.stars,
                            );
                          },
                        ),
                      ),

                      // const SizedBox(height: 8),
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