import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/presentation/sessions/pages/pending_sessions_page.dart';
import 'package:skill_swap/presentation/sessions/pages/requests_sessions_page.dart';
import 'package:skill_swap/presentation/sessions/pages/upcoming_sessions_page.dart';
import 'package:skill_swap/presentation/sessions/widgets/session_header.dart';
import '../pages/all_sessions_page.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  int selected = 0;
  final pages = [
    AllSessionsPage(),
    UpcomingSessionsPage(),
    PendingSessionsPage(),
    RequestsSessionsPage()
  ];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
     // backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
          children: [
            SessionsHeader(
                selectedIndex: selected,
                onSelect: (index) {
                  setState(() {
                    selected = index;
                  });
                },
                title: "sessions".tr,
                subtitle: "track_upcoming".tr,

            )
          ],
          ),
          Positioned(
              top: 164,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: screenHeight),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: pages[selected],
                ),
              )
          )
        ],
      ),
    );
  }
}


