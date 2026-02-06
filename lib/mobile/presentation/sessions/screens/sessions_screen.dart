import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/all_sessions_page.dart';
import '../pages/pending_sessions_page.dart';
import '../pages/requests_sessions_page.dart';
import '../pages/upcoming_sessions_page.dart';
import '../widgets/session_header.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
            top: screenHeight * 0.15, // responsive top position
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(screenWidth * 0.06), // responsive radius
                  topRight: Radius.circular(screenWidth * 0.06),
                ),
              ),
              child: SingleChildScrollView(
                child: pages[selected],
              ),
            ),
          )
        ],
      ),
    );
  }
}
