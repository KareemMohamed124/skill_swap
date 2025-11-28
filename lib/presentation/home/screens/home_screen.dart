import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/common_ui/custom_bottom_nav.dart';
import 'package:skill_swap/constants/strings.dart';
import 'package:skill_swap/presentation/home/widgets/custom_header.dart';
import '../../../constants/colors.dart';
import '../widgets/next_session_card.dart';
import '../widgets/next_session_view_all.dart';
import '../widgets/recommended_card.dart';
import '../widgets/recommended_view_all.dart';
import '../widgets/section_header.dart';
import '../widgets/top_user_card.dart';
import '../widgets/top_users_view_all.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomHeader(
                name: 'Hi, Nada',
                subtitle: 'Keep learning and earning hours today!',
                avatar: 'assets/images/people_images/nada.jpg',
                onIcon1: () {},
                onIcon2: () {},
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

                      // Top Users Section
                      SectionHeader(sectionTitle: 'Top Users', onTop: () { Get.to(TopUsersViewAll()); },),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 143,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppStrings.imagesTopUsers.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return TopUserCard(
                              image: AppStrings.imagesTopUsers[index],
                              name: AppStrings.namesTopUsers[index],
                              track: AppStrings.tracksTopUsers[index],
                              hours: AppStrings.hoursTopUsers[index],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Your Next Session Section
                       SectionHeader(sectionTitle: 'Your Next Session', onTop: () { Get.to(NextSessionViewAll()); },),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: AppStrings.imagesNextSessions.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return NextSessionCard(
                            image: AppStrings.imagesNextSessions[index],
                            name: AppStrings.namesTopUsers[index],
                            duration: AppStrings.durationNextSessions[index],
                            time: AppStrings.timeNextSessions[index],
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Recommended Section (reusable)
                      SectionHeader(sectionTitle: 'Recommended for You', onTop: () {Get.to(RecommendedViewAll());  },),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 233,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppStrings.imagesRecommended.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return RecommendedCard(
                              image: AppStrings.imagesRecommended[index],
                              name: AppStrings.namesRecommended[index],
                              track: AppStrings.trackRecommended[index],
                              rating: AppStrings.starsRecommended[index],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}

