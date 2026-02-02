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

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
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
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  ProfileTabs(
                    tabController: _tabController,
                    tabs: ['completed'.tr, 'cancelled'.tr, 'issue'.tr, 'reviews'.tr],
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

              // child: ListView.builder(
              //   padding: const EdgeInsets.all(16),
              //   itemCount: AppData.notificationCard.length,
              //   itemBuilder: (context, index) {
              //     final item = AppData.notificationCard[index];
              //
              //     return NotificationCard(
              //         bgColor: item.bgColor,
              //         borderColor: item.borderColor,
              //         tag: item.tag,
              //         tagColor: item.tagColor,
              //         timeAgo: item.timeAgo,
              //         title: item.title,
              //         mentorName: item.mentorName,
              //         sessionTime: item.sessionTime,
              //         icon: item.icon
              //     );
              //   },
              // ),
            ),
          )
        ],
      ),
    );
  }
}