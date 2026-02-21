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
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';

import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../home/screens/home_content.dart';
import 'desktop_scaffold.dart';
import 'desktop_sidebar.dart';

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

  final List<_PageState> _history = [];

  @override
  void initState() {
    super.initState();
    openPage(index: 0);
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return HomeContent();

      case 1:
        return ChatListScreen(
          onChannelSelected: (channel) {
            openSidePage(
              body: getBody(1),
              rightPanel: ChatScreen(channelName: channel),
            );
          },
        );

      case 2:
        return BlocProvider(
          create: (_) => sl<UserFilterBloc>(),
          child: const SearchScreen(),
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

  final List<Widget?> rightPanels = [
    NotificationDesktopPanel(),
    null,
    BlocProvider(
      create: (_) => sl<MentorFilterBloc>(),
      child: MentorFilterSheet(),
    ),
    null,
    null,
    null
  ];

  void openPage({required int index}) {
    setState(() {
      currentIndex = index;
      currentBody = getBody(index);
      currentRightPanel = rightPanels[index];
      _history.clear();
    });
  }

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

  bool goBack() {
    if (_history.isNotEmpty) {
      final last = _history.removeLast();
      setState(() {
        currentBody = last.body;
        currentRightPanel = last.rightPanel;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyProfileCubit>(
          create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
        ),
        BlocProvider<UsersCubit>(
          create: (_) => sl<UsersCubit>()..fetchUsers(),
        ),
        BlocProvider(create: (_) => sl<LogoutBloc>())
      ],
      child: DesktopScaffold(
        sidebar: DesktopSidebar(
          currentIndex: currentIndex,
          onItemSelected: (index) => openPage(index: index),
        ),
        body: currentBody!,
        rightPanel: currentRightPanel,
      ),
    );
  }
}
