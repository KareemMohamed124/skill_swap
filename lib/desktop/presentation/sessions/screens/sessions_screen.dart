import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_tabs.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/all_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/pending_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/requests_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/upcoming_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/widgets/session_header.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            SessionsHeader(
              title: "sessions".tr,
              subtitle: "track_upcoming".tr,

            ),
            ProfileTabs(
              tabController: _tabController,
              tabs: ['all'.tr, 'accepted'.tr, 'pending'.tr, 'request'.tr],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AllSessionsPage(),
                  UpcomingSessionsPage(),
                  PendingSessionsPage(),
                  RequestsSessionsPage()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}