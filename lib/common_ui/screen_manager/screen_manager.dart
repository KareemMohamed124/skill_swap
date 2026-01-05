import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../dependency_injection/injection.dart';
import '../../presentation/chat_channel/chat_screen.dart';
import '../../presentation/chat_channel/chat_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/search/screens/search_screen.dart';
import '../../presentation/sessions/screens/sessions_screen.dart';
import '../custom_bottom_nav.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int currentIndex = 0;

  final screens = [
    const HomeScreen(),
    const ChatScreen(channelName: '',),
    BlocProvider(
        create: (_) => sl<MentorFilterBloc>(),
        child: const SearchScreen(),
    ),

    const SessionsScreen(),
    const ProfileScreen(),
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