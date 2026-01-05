import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/chat_channel/chat_list.dart';
import 'package:skill_swap/presentation/home/screens/home_screen.dart';
import 'package:skill_swap/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/presentation/search/screens/search_screen.dart';
import 'package:skill_swap/presentation/sessions/screens/sessions_screen.dart';
import '../custom_bottom_nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../dependency_injection/injection.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int currentIndex = 0;

  final screens = [
    const HomeScreen(),
    ChatListScreen(),
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
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}