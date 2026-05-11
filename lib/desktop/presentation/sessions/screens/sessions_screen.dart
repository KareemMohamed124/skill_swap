import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_tabs.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/pending_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/requests_sessions_page.dart';
<<<<<<< HEAD
import 'package:skill_swap/desktop/presentation/sessions/pages/rjected_session_page.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:skill_swap/desktop/presentation/sessions/pages/upcoming_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/widgets/session_header.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';

class SessionsScreen extends StatefulWidget {
<<<<<<< HEAD
  final int initialTab;

  const SessionsScreen({
    super.key,
    this.initialTab = 0,
  });
=======
  const SessionsScreen({super.key});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _fetchByIndex(_tabController.index);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchByIndex(_tabController.index);
    });
  }

  @override
  void didUpdateWidget(covariant SessionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab);
      _fetchByIndex(widget.initialTab);
    }
  }

  void _fetchByIndex(int index) {
    final cubit = context.read<GetBookingsCubit>();

    switch (index) {
      case 0:
        cubit.fetchAllBookings("accepted");
        break;
      case 1:
        cubit.fetchAllBookings("pending");
        break;
      case 2:
        cubit.fetchAllBookings("request");
      case 3:
        cubit.fetchAllBookings("rejected");
        break;
    }
=======
    _tabController = TabController(length: 3, vsync: this);

    // Fetch bookings for the first tab initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetBookingsCubit>().fetchAllBookings("accepted");
    });

    // Listen to tab changes to fetch data per tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // ignore swipe in progress
      switch (_tabController.index) {
        case 0:
          context.read<GetBookingsCubit>().fetchAllBookings("accepted");
          break;
        case 1:
          context.read<GetBookingsCubit>().fetchAllBookings("pending");
          break;
        case 2:
          context.read<GetBookingsCubit>().fetchAllBookings("request");
          break;
      }
    });
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
              tabs: ['accepted'.tr, 'pending'.tr, 'request'.tr, 'rejected'],
=======
              tabs: ['accepted'.tr, 'pending'.tr, 'request'.tr],
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
<<<<<<< HEAD
                children: [
                  UpcomingSessionsPage(),
                  PendingSessionsPage(),
                  RequestsSessionsPage(),
                  RejectedSessionsPage()
=======
                children: const [
                  UpcomingSessionsPage(),
                  PendingSessionsPage(),
                  RequestsSessionsPage()
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
