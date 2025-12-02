import 'package:flutter/material.dart';

import '../../presentation/chat_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/search_screen.dart';
import '../../presentation/session_screen.dart';
import '../custom_bottom_nav.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    ChatScreen(),
    SearchScreen(),
    SessionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}