import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/auth_repository.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../notification/screens/notification_screen.dart';
import '../pages/next_session_view_all.dart';
import '../pages/recommended_view_all.dart';
import '../pages/top_users_view_all.dart';
import '../widgets/custom_header.dart';
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
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final localUser = await LocalStorage.getUser();
    if (mounted && localUser != null) {
      setState(() {
        user = localUser;
      });
    }

    try {
      final repo = sl<AuthRepository>();
      final freshUser = await repo.getProfile();
      await LocalStorage.saveUser(freshUser);

      if (mounted) {
        setState(() {
          user = freshUser;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomHeader(
                name: user?.name != null ? 'Hi, ${user!.name}' : 'Hi, Kemo',
                subtitle: 'keep_learning'.tr,
                avatarPath: user?.imagePath ?? '',
                onIcon1: () {},
                onIcon2: () {
                  Get.to(NotificationsScreen());
                },
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.15, // بدل 132
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.85),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.06), // بدل 24
                  topRight: Radius.circular(screenWidth * 0.06), // بدل 24
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04), // بدل 16
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Users
                      SectionHeader(
                        sectionTitle: 'top_users'.tr,
                        onTop: () {
                          Get.to(TopUsersViewAll());
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01), // بدل 8
                      SizedBox(
                        height: screenHeight * 0.15, // بدل 128
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppData.topUsers.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: screenWidth * 0.04), // بدل 16
                          itemBuilder: (context, index) {
                            final u = AppData.topUsers[index];
                            return TopUserCard(
                              id: u.id,
                              image: u.image,
                              name: u.name,
                              track: u.track,
                              hours: u.hours,
                            );
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03), // بدل 24

                      /// Next Session
                      SectionHeader(
                        sectionTitle: 'your_next_session'.tr,
                        onTop: () {
                          Get.to(NextSessionViewAll());
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01), // بدل 8
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: AppData.nextSessions.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: screenHeight * 0.01), // بدل 8
                        itemBuilder: (context, index) {
                          final s = AppData.nextSessions[index];
                          return NextSessionCard(
                            name: s.name,
                            duration: s.duration,
                            dateTime: s.dateTime,
                            startsIn: s.startsIn,
                            isMentor: s.isMentor,
                          );
                        },
                      ),

                      SizedBox(height: screenHeight * 0.03), // بدل 24

                      /// Recommended
                      SectionHeader(
                        sectionTitle: 'recommended_for_you'.tr,
                        onTop: () {
                          Get.to(RecommendedViewAll());
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01), // بدل 8
                      SizedBox(
                        height: screenHeight * 0.21, // بدل 180
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppData.recommendedMentors.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: screenWidth * 0.04), // بدل 16
                          itemBuilder: (context, index) {
                            final m = AppData.recommendedMentors[index];
                            return RecommendedCard(
                              id: m.id,
                              image: m.image,
                              name: m.name,
                              track: m.track,
                              rating: m.stars,
                            );
                          },
                        ),
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
