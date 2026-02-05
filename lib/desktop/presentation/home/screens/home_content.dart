import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/home/pages/next_session_view_all.dart';
import 'package:skill_swap/desktop/presentation/home/pages/recommended_view_all.dart';
import 'package:skill_swap/desktop/presentation/home/pages/top_users_view_all.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/next_session_card.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/recommended_card.dart' show RecommendedCard;
import 'package:skill_swap/desktop/presentation/home/widgets/section_header.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/top_user_card.dart';
import 'package:skill_swap/main.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/auth_repository.dart';
import '../../../../shared/helper/local_storage.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;


class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final localUser = await LocalStorage.getUser();
    if (mounted && localUser != null) {
      setState(() => user = localUser);
    }

    try {
      final repo = sl<AuthRepository>();
      final freshUser = await repo.getProfile();
      await LocalStorage.saveUser(freshUser);
      if (mounted) setState(() => user = freshUser);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {

    final imagePath = user?.imagePath;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade800, width: 1),
                ),
              ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      backgroundImage: (hasImage && defaultTargetPlatform != TargetPlatform.windows)
                          ? FileImage(File(imagePath))
                          : null,
                      child: (!hasImage || defaultTargetPlatform == TargetPlatform.windows)
                          ? Icon(Icons.person, size: 24, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          user?.name != null ? 'Hi, ${user!.name}' : 'Hi, Kemo',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'keep_learning'.tr,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ),
                /// Greeting

                const SizedBox(height: 24),

                /// Top Users
                SectionHeader(
                  sectionTitle: 'top_users'.tr,
                  onTop: () => desktopKey.currentState?.openSidePage(
                      body: TopUsersViewAll()
                  )
                ),
                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.topUsers.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (_, i) {
                    final u = AppData.topUsers[i];
                    return TopUserCard(
                      id: u.id,
                      image: u.image,
                      name: u.name,
                      track: u.track,
                      hours: u.hours,
                    );
                  },
                ),

                const SizedBox(height: 40),

                /// Next Sessions
                SectionHeader(
                  sectionTitle: 'your_next_session'.tr,
                    onTop: () => desktopKey.currentState?.openSidePage(
                        body: NextSessionViewAll()
                    )
                ),
                const SizedBox(height: 16),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.nextSessions.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final s = AppData.nextSessions[i];
                    return NextSessionCard(
                      name: s.name,
                      duration: s.duration,
                      dateTime: s.dateTime,
                      startsIn: s.startsIn,
                      isMentor: s.isMentor,
                    );
                  },
                ),

                const SizedBox(height: 40),

                /// Recommended
                SectionHeader(
                  sectionTitle: 'recommended_for_you'.tr,
                    onTop: () => desktopKey.currentState?.openSidePage(
                        body: RecommendedViewAll()
                    )
                ),
                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.recommendedMentors.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) {
                    final m = AppData.recommendedMentors[i];
                    return RecommendedCard(
                      id: m.id,
                      image: m.image,
                      name: m.name,
                      track: m.track,
                      rating: m.stars,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}