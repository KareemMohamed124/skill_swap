import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
<<<<<<< HEAD
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../pages/pending_sessions_page.dart';
import '../pages/requests_sessions_page.dart';
import '../pages/rjected_session_page.dart';
=======
import '../pages/pending_sessions_page.dart';
import '../pages/requests_sessions_page.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../pages/upcoming_sessions_page.dart';
import '../widgets/session_header.dart';

class SessionsScreen extends StatefulWidget {
<<<<<<< HEAD
  final int initialTab;

  const SessionsScreen({super.key, this.initialTab = 0});
=======
  const SessionsScreen({super.key});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  int selected = 0;

  final pages = const [
    UpcomingSessionsPage(),
    PendingSessionsPage(),
    RequestsSessionsPage(),
<<<<<<< HEAD
    RejectedSessionsPage()
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  ];

  String get currentStatus {
    switch (selected) {
      case 0:
        return "accepted";
      case 1:
        return "pending";
      case 2:
        return "pending";
<<<<<<< HEAD
      case 3:
        return "rejected";
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      default:
        return "accepted";
    }
  }

  @override
<<<<<<< HEAD
  void initState() {
    super.initState();
    selected = widget.initialTab;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetBookingsCubit>().fetchAllBookings("accepted");

      context.read<PurchaseCubit>().getPurchases();
    });
  }

  @override
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SessionsHeader(
                selectedIndex: selected,
                onSelect: (index) {
                  setState(() => selected = index);
                  context
                      .read<GetBookingsCubit>()
                      .fetchAllBookings(currentStatus);
<<<<<<< HEAD
                  context.read<PurchaseCubit>().getPurchases();
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                },
                title: "sessions".tr,
                subtitle: "track_upcoming".tr,
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.21,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: screenHeight),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.06),
                    topRight: Radius.circular(screenWidth * 0.06),
                  ),
                ),
                child: pages[selected]),
          ),
        ],
      ),
    );
  }
}
