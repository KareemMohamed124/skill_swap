import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../mobile/presentation/chat_channel/chat_list.dart';
import '../../../mobile/presentation/home/screens/home_screen.dart';
import '../../../mobile/presentation/profile/screens/profile_screen.dart';
import '../../../mobile/presentation/search/screens/search_screen.dart';
import '../../../mobile/presentation/sessions/screens/sessions_screen.dart';
import '../../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../dependency_injection/injection.dart';
import '../custom_bottom_nav.dart';

class ScreenManager extends StatefulWidget {
  final int initialIndex;

  const ScreenManager({super.key, this.initialIndex = 0});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  late final List<Widget> screens = [
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
    // الحصول على حجم الشاشة
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      // نستخدم SizedBox.expand لضمان ملء المساحة بشكل ديناميكي
      body: SizedBox.expand(
        child: IndexedStack(
          index: currentIndex,
          children: screens.map((screen) {
            return SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: screen,
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
