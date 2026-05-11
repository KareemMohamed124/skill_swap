import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/overview_page.dart';
import '../pages/reviews_page.dart';
import '../pages/skills_page.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tabs.dart';

class ProfileScreen extends StatefulWidget {
<<<<<<< HEAD
  final int initialTab;

  const ProfileScreen({super.key, this.initialTab = 0});
=======
  const ProfileScreen({Key? key}) : super(key: key);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
=======
    _tabController = TabController(length: 3, vsync: this);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
=======
    final screenHeight = MediaQuery.of(context).size.height;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            // BlocProvider(
            //     create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
            //     child: const ProfileHeader()),
            const ProfileHeader()
          ]),
          Positioned(
            top: 184,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
=======
                color: Theme.of(context).scaffoldBackgroundColor,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  ProfileTabs(
                      tabController: _tabController,
                      tabs: ['overview'.tr, 'skills'.tr, 'reviews'.tr]),
                  Expanded(
                      child: TabBarView(
<<<<<<< HEAD
                        controller: _tabController,
                        children: const [
                          OverviewPage(),
                          SkillsPage(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: ReviewsPage(),
                          ),
                        ],
                      )),
=======
                    controller: _tabController,
                    children: const [
                      OverviewPage(),
                      SkillsPage(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: ReviewsPage(),
                      ),
                    ],
                  )),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
