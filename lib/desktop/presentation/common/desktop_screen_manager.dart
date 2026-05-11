import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_list.dart';
<<<<<<< HEAD
import 'package:skill_swap/desktop/presentation/game_store/screens/store_screen.dart';
import 'package:skill_swap/desktop/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/desktop/presentation/search/screens/search_screen.dart';
=======
import 'package:skill_swap/desktop/presentation/chat_channel/pages/chat_screen.dart';
import 'package:skill_swap/desktop/presentation/home/screens/notification_desktop_panel.dart';
import 'package:skill_swap/desktop/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/desktop/presentation/search/screens/search_screen.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filterSheet.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:skill_swap/desktop/presentation/sessions/screens/sessions_screen.dart';
import 'package:skill_swap/desktop/presentation/setting/screens/setting.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';

<<<<<<< HEAD
import '../../../shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../shared/bloc/private_chats_bloc/private_chats_bloc.dart';
import '../../../shared/bloc/public_chat/public_chat_bloc.dart';
import '../../../shared/bloc/public_chat/public_chat_event.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/status_book_bloc/status_book_bloc.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_event.dart';
=======
import '../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
  final int initialIndex;
  final int initialSessionTab;
  final int initialProfileTab;

  const DesktopScreenManager({
    super.key,
    this.initialIndex = 0,
    this.initialSessionTab = 0,
    this.initialProfileTab = 0,
  });
=======
  const DesktopScreenManager({super.key});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  State<DesktopScreenManager> createState() => DesktopScreenManagerState();
}

class DesktopScreenManagerState extends State<DesktopScreenManager> {
  int currentIndex = 0;

<<<<<<< HEAD
  late int initialSessionTab;
  late int initialProfileTab;

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  Widget? currentBody;
  Widget? currentRightPanel;

  final List<_PageState> _history = [];
<<<<<<< HEAD
  late final PublicChatMessagesCubit _chatMessagesCubit =
  sl<PublicChatMessagesCubit>();
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

    currentIndex = widget.initialIndex;
    initialSessionTab = widget.initialSessionTab;
    initialProfileTab = widget.initialProfileTab;

    openPage(index: currentIndex);
  }

  @override
  void dispose() {
    _chatMessagesCubit.close();
    super.dispose();
=======
    openPage(index: 0);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
<<<<<<< HEAD
        return MultiBlocProvider(providers: [
          BlocProvider<UsersCubit>(
            create: (_) => sl<UsersCubit>(),
          ),
          BlocProvider<GetBookingsCubit>(create: (_) => sl<GetBookingsCubit>()),
          BlocProvider<PrivateChatsBloc>(create: (_) => sl<PrivateChatsBloc>())
        ], child: HomeContent());

      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) =>
                sl<TracksBloc>()
                  ..add(LoadTracksEvent())),
            BlocProvider(
                create: (_) =>
                sl<PublicChatBloc>()
                  ..add(GetPublicChatsEvent())),
            BlocProvider(
              create: (_) => sl<PurchaseCubit>(),
            )
          ],
          child: ChatListScreen(),
        );

      case 2:
        return MultiBlocProvider(providers: [
          BlocProvider(
            create: (_) => sl<UserFilterBloc>(),
          ),
          BlocProvider(
            create: (_) => sl<TracksCubit>(),
          ),
        ], child: const SearchScreen(),
        );

      case 3:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) =>
                sl<GetBookingsCubit>()
                  ..fetchAllBookings("accepted")),
            BlocProvider(create: (_) => sl<StatusBookBloc>()),
            BlocProvider(
                create: (_) =>
                sl<PurchaseCubit>()
                  ..getAvailableVouchers())
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
        return BlocProvider(
          create: (_) =>
          sl<StoreCubit>()
            ..getStoreItems(freeOnly: false),
          child: const StoreScreen(),
        );

      case 6:
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        return SettingScreen();

      default:
        return HomeContent();
    }
  }

  final List<Widget?> rightPanels = [
<<<<<<< HEAD
    //  NotificationDesktopPanel(),
    null,
    null,
    null,
    null,
    null,
    null,
    null,
=======
    NotificationDesktopPanel(),
    null,
    BlocProvider(
      create: (_) => sl<MentorFilterBloc>(),
      child: MentorFilterSheet(),
    ),
    null,
    null,
    null
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  ];

  void openPage({required int index}) {
    setState(() {
      currentIndex = index;
      currentBody = getBody(index);
      currentRightPanel = rightPanels[index];
      _history.clear();
    });
  }

<<<<<<< HEAD
  void openSidePage({
    required Widget body,
    Widget? rightPanel,
  }) {
=======
  void openSidePage({required Widget body, Widget? rightPanel}) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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

<<<<<<< HEAD
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
    initialProfileTab = tab;
    openPage(index: 4);
  }

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
<<<<<<< HEAD
        BlocProvider(
          create: (_) =>
          sl<MyProfileCubit>()
            ..fetchMyProfile(),
        ),
        BlocProvider(create: (_) => sl<UsersCubit>()),
        BlocProvider(create: (_) => sl<GetBookingsCubit>()),
        BlocProvider(create: (_) => sl<LogoutBloc>()),
        BlocProvider(create: (_) => sl<DeleteAccountBloc>()),
=======
        BlocProvider<MyProfileCubit>(
          create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
        ),
        BlocProvider<UsersCubit>(
          create: (_) => sl<UsersCubit>(),
        ),
        BlocProvider<GetBookingsCubit>(create: (_) => sl<GetBookingsCubit>()),
        BlocProvider(create: (_) => sl<LogoutBloc>())
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
