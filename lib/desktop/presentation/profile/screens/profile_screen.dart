import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_header.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_tabs.dart';
import '../pages/overview_page.dart';
import '../pages/skills_page.dart';
import '../pages/reviews_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            const ProfileHeader(),  // 👈 الهيدر
           // const SizedBox(height: 24),
            ProfileTabs(
              tabController: _tabController,
              tabs: ['overview'.tr, 'skills'.tr, 'reviews'.tr],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  OverviewPage(),
                  SkillsPage(),
                  ReviewsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}