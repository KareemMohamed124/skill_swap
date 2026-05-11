import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../profile/widgets/profile_tabs.dart';
<<<<<<< HEAD
import '../pages/completed_page.dart';
=======
import '../pages/cancel_page.dart';
import '../pages/completed_page.dart';
import '../pages/issue_page.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../pages/review_page.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _tabController = TabController(length: 2, vsync: this);
=======
    _tabController = TabController(length: 4, vsync: this);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "history_sessions".tr,
        child: Column(
          children: [
            ProfileTabs(
              tabController: _tabController,
<<<<<<< HEAD
              tabs: ['completed'.tr, /*'cancelled'.tr*/ 'reviews'.tr],
=======
              tabs: ['completed'.tr, 'cancelled'.tr, 'issue'.tr, 'reviews'.tr],
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  CompletedSessionsPage(),
<<<<<<< HEAD
                  // CancelSessionsPage(),
                  //IssueSessionsPage(),
=======
                  CancelSessionsPage(),
                  IssueSessionsPage(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  ReviewSessionsPage()
                ],
              ),
            ),
          ],
        ));
  }
}
