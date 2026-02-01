import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/constants/strings.dart';
import 'package:skill_swap/data/models/user/user_model.dart';
import 'package:skill_swap/presentation/home/widgets/custom_header.dart';
import 'package:skill_swap/presentation/notification/screens/notification_screen.dart';
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

    return Scaffold(
    //  backgroundColor: AppColor.whiteColor,
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
            top: 132,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
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
                      /// Top Users
                      SectionHeader(
                        sectionTitle: 'top_users'.tr,
                        onTop: () {
                          Get.to(TopUsersViewAll());
                        },
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 128,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppData.topUsers.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 16),
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

                      const SizedBox(height: 24),

                      /// Next Session
                      SectionHeader(
                        sectionTitle: 'your_next_session'.tr,
                        onTop: () {
                          Get.to(NextSessionViewAll());
                        },
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: AppData.nextSessions.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
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

                      const SizedBox(height: 24),

                      /// Recommended
                      SectionHeader(
                        sectionTitle: 'recommended_for_you'.tr,
                        onTop: () {
                          Get.to(RecommendedViewAll());
                        },
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppData.recommendedMentors.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 16),
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