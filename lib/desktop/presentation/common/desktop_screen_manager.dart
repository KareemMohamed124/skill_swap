import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_list.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_screen.dart';
import 'package:skill_swap/desktop/presentation/game_store/screens/store_screen.dart';
import 'package:skill_swap/desktop/presentation/home/screens/notification_desktop_panel.dart';
import 'package:skill_swap/desktop/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/desktop/presentation/search/screens/search_screen.dart';
import 'package:skill_swap/desktop/presentation/sessions/screens/sessions_screen.dart';
import 'package:skill_swap/desktop/presentation/setting/screens/setting.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';

import '../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_bloc.dart';
import '../../../shared/bloc/public_chat/public_chat_event.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/status_book_bloc/status_book_bloc.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_event.dart';
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
  final int initialIndex;
  final int initialSessionTab;
  final int initialProfileTab;

  const DesktopScreenManager({
    super.key,
    this.initialIndex = 0,
    this.initialSessionTab = 0,
    this.initialProfileTab = 0,
  });

  @override
  State<DesktopScreenManager> createState() => DesktopScreenManagerState();
}

class DesktopScreenManagerState extends State<DesktopScreenManager> {
  int currentIndex = 0;

  late int initialSessionTab;
  late int initialProfileTab;

  Widget? currentBody;
  Widget? currentRightPanel;

  final List<_PageState> _history = [];
  late final PublicChatMessagesCubit _chatMessagesCubit =
      sl<PublicChatMessagesCubit>();

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    initialSessionTab = widget.initialSessionTab;
    initialProfileTab = widget.initialProfileTab;

    openPage(index: currentIndex);
  }

  @override
  void dispose() {
    _chatMessagesCubit.close();
    super.dispose();
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return HomeContent();

      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) => sl<TracksBloc>()..add(LoadTracksEvent())),
            BlocProvider(
                create: (_) =>
                    sl<PublicChatBloc>()..add(GetPublicChatsEvent())),
          ],
          child: ChatListScreen(
            onChannelSelected: (chatId, channelName) {
              openSidePage(
                body: currentBody ?? getBody(currentIndex),
                rightPanel: BlocProvider.value(
                  value: _chatMessagesCubit,
                  child: ChatScreen(
                    chatId: chatId,
                    channelName: channelName,
                  ),
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
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<GetBookingsCubit>()),
            BlocProvider(create: (_) => sl<StatusBookBloc>()),
            BlocProvider(create: (_) => sl<PurchaseCubit>()),
          ],
          child: SessionsScreen(
            initialTab: initialSessionTab,
          ),
        );

      case 4:
        return ProfileScreen(
          initialTab: initialProfileTab,
        );

      case 5:
        return StoreScreen();

      case 6:
        return SettingScreen();

      default:
        return HomeContent();
    }
  }

  final List<Widget?> rightPanels = [
    NotificationDesktopPanel(),
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  void openPage({required int index}) {
    setState(() {
      currentIndex = index;
      currentBody = getBody(index);
      currentRightPanel = rightPanels[index];
      _history.clear();
    });
  }

  void openSidePage({
    required Widget body,
    Widget? rightPanel,
  }) {
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

  void openSessions({int tab = 0}) {
    setState(() {
      currentIndex = 3;
      initialSessionTab = tab;
      currentBody = getBody(3);
      currentRightPanel = rightPanels[3];
      _history.clear();
    });
  }

  void openProfile({int tab = 0}) {
    setState(() {
      currentIndex = 4;
      initialProfileTab = tab;
      currentBody = getBody(4);
      currentRightPanel = rightPanels[4];
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
        ),
        BlocProvider(create: (_) => sl<UsersCubit>()),
        BlocProvider(create: (_) => sl<GetBookingsCubit>()),
        BlocProvider(create: (_) => sl<LogoutBloc>()),
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
