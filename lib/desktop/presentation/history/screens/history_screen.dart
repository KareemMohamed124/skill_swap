import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD

import '../../../../main.dart';
import '../../profile/widgets/profile_tabs.dart';
import '../pages/completed_page.dart';
=======
import '../../../../main.dart';
import '../../../../shared/common_ui/header.dart';
import '../../profile/widgets/profile_tabs.dart';
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

<<<<<<< HEAD
class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
=======
class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
    return Center(
=======
  @override
  Widget build(BuildContext context) {
     return Center(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
<<<<<<< HEAD
                  onPressed: () {
                    final didGoBack = desktopKey.currentState?.goBack();
                    if (didGoBack == false) {
                      desktopKey.currentState?.openPage(index: 0);
                    }
                  },
                ),
                SizedBox(
                  width: 16,
                ),
=======
                    onPressed: () {
                      final didGoBack = desktopKey.currentState?.goBack();
                      if(didGoBack == false) {
                        desktopKey.currentState?.openPage(index: 0);
                      }
                    },
                ),
                SizedBox(width: 16,),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                Text(
                  "history_sessions".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
<<<<<<< HEAD
            SizedBox(
              height: 16,
            ),
            ProfileTabs(
              tabController: _tabController,
              tabs: ['completed'.tr, 'reviews'.tr],
=======
            SizedBox(height: 16,),
            ProfileTabs(
              tabController: _tabController,
              tabs: ['completed'.tr, 'cancelled'.tr, 'issue'.tr, 'reviews'.tr],
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  CompletedSessionsPage(),
<<<<<<< HEAD
                  //CancelSessionsPage(),
                  //IssueSessionsPage(),
                  ReviewSessionsPage()
=======
                  CancelSessionsPage(),
                  IssueSessionsPage(),
                   ReviewSessionsPage()
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                ],
              ),
            ),
          ],
        ),
      ),
    );
<<<<<<< HEAD
  }
}
=======

  }
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
