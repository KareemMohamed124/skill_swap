import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_list.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_screen.dart';
import 'package:skill_swap/desktop/presentation/home/screens/notification_desktop_panel.dart';
import 'package:skill_swap/desktop/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/desktop/presentation/search/screens/search_screen.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filterSheet.dart';
import 'package:skill_swap/desktop/presentation/sessions/screens/sessions_screen.dart';
import 'package:skill_swap/desktop/presentation/setting/screens/setting.dart';
import '../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../home/screens/home_content.dart';
import 'desktop_scaffold.dart';
import 'desktop_sidebar.dart';

/// 📝 Helper class to store page state
class _PageState {
  final Widget body;
  final Widget? rightPanel;

  _PageState({required this.body, this.rightPanel});
}

class DesktopScreenManager extends StatefulWidget {
  const DesktopScreenManager({super.key});

  @override
  State<DesktopScreenManager> createState() => DesktopScreenManagerState();
}

class DesktopScreenManagerState extends State<DesktopScreenManager> {
  int currentIndex = 0;

  Widget? currentBody;
  Widget? currentRightPanel;

  /// Stack to save history of pages
  final List<_PageState> _history = [];

  @override
  void initState() {
    super.initState();
    openPage(index: 0);
  }

  /// Get body based on bottom menu / sidebar index
  Widget getBody(int index) {
    switch (index) {
      case 0:
        return HomeContent();

      case 1:
        return ChatListScreen(
          onChannelSelected: (channel) {
            // When opening chat, push current state to history
            openSidePage(
              body: getBody(1),
              rightPanel: ChatScreen(channelName: channel),
            );
          },
        );

      case 2:
        return BlocProvider(
          create: (_) => sl<MentorFilterBloc>(),
          child: SearchScreen(),
        );

      case 3:
        return SessionsScreen();

      case 4:
        return ProfileScreen();

      case 5:
        return SettingScreen();

      default:
        return HomeContent();
    }
  }

  /// Default right panels for each index
  final List<Widget?> rightPanels = [
    NotificationDesktopPanel(),
    null,
    BlocProvider(
      create: (_) => sl<MentorFilterBloc>(),
      child: MentorFilterSheet(),
    ),
    // MentorFilterSheet(),
    null,
    null,
    null
  ];

  /// Open page from sidebar / menu
  void openPage({required int index}) {
    setState(() {
      currentIndex = index;
      currentBody = getBody(index);
      currentRightPanel = rightPanels[index];
      _history.clear(); // Clear history when navigating main pages
    });
  }

  /// Open side page (like chat or detail) and save current state
  void openSidePage({required Widget body, Widget? rightPanel}) {
    _history.add(_PageState(
      body: currentBody!,
      rightPanel: currentRightPanel,
    ));

    setState(() {
      currentBody = body;
      if (rightPanel != null) currentRightPanel = rightPanel;
    });
  }

  /// Go back to previous page (called by back button)
  bool goBack() {
    if (_history.isNotEmpty) {
      final last = _history.removeLast();
      setState(() {
        currentBody = last.body;
        currentRightPanel = last.rightPanel;
      });
      return true; // Successfully went back
    }
    return false; // No page to go back to
  }

  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      sidebar: DesktopSidebar(
        currentIndex: currentIndex,
        onItemSelected: (index) => openPage(index: index),
      ),
      body: currentBody!,
      rightPanel: currentRightPanel,
    );
  }
}