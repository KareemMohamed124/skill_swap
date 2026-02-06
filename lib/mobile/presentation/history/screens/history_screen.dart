import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/common_ui/header.dart';
import '../../profile/widgets/profile_tabs.dart';
import '../pages/cancel_page.dart';
import '../pages/completed_page.dart';
import '../pages/issue_page.dart';
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: "history_sessions".tr),
            ],
          ),
          Positioned(
            top: screenHeight * 0.1, // بدل 80
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.9),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.08), // بدل 32
                  topRight: Radius.circular(screenWidth * 0.08), // بدل 32
                ),
              ),
              child: Column(
                children: [
                  ProfileTabs(
                    tabController: _tabController,
                    tabs: [
                      'completed'.tr,
                      'cancelled'.tr,
                      'issue'.tr,
                      'reviews'.tr
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        CompletedSessionsPage(),
                        CancelSessionsPage(),
                        IssueSessionsPage(),
                        ReviewSessionsPage()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
