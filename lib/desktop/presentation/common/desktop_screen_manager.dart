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

import '../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../shared/core/network/pusher_service.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../../../shared/helper/local_storage.dart';
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
    _initPusher();
  }

  Future<void> _initPusher() async {
    final userId = await LocalStorage.getUserId();
    if (userId != null && userId.isNotEmpty) {
      await sl<PusherService>().init(userId: userId);
    }
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return HomeContent();

      case 1:
        return BlocProvider(
          create: (_) => sl<TracksBloc>()..add(LoadTracksEvent()),
          child: ChatListScreen(
            onChannelSelected: (chatId, channelName) {
              openSidePage(
                body: BlocProvider(
                  create: (_) => sl<TracksBloc>()..add(LoadTracksEvent()),
                  child: ChatListScreen(
                    selectedChannel: channelName,
                    onChannelSelected: (cId, cName) {
                      setState(() {
                        currentRightPanel = ChatScreen(
                          key: ValueKey(cId),
                          chatId: cId,
                          channelName: cName,
                        );
                      });
                    },
                  ),
                ),
                rightPanel: ChatScreen(
                  key: ValueKey(chatId),
                  chatId: chatId,
                  channelName: channelName,
                ),
              );
            },
          ),
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
          create: (_) => sl<UsersCubit>(),
        ),
        BlocProvider<GetBookingsCubit>(create: (_) => sl<GetBookingsCubit>()),
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
