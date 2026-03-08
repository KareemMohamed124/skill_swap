import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../mobile/presentation/chat_channel/chat_list.dart';
import '../../../mobile/presentation/home/screens/home_screen.dart';
import '../../../mobile/presentation/profile/screens/profile_screen.dart';
import '../../../mobile/presentation/search/screens/search_screen.dart';
import '../../../mobile/presentation/sessions/screens/sessions_screen.dart';
import '../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../bloc/status_book_bloc/status_book_bloc.dart';
import '../../bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../bloc/tracks_bloc/tracks_bloc.dart';
import '../../bloc/tracks_bloc/tracks_event.dart';
import '../../bloc/user_filter_bloc/user_filter_bloc.dart';
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
    MultiBlocProvider(providers: [
      // BlocProvider<MyProfileCubit>(
      //   create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
      // ),
      BlocProvider<UsersCubit>(
        create: (_) => sl<UsersCubit>(),
      ),
      BlocProvider<GetBookingsCubit>(create: (_) => sl<GetBookingsCubit>())
    ], child: HomeScreen()),
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => sl<TracksBloc>()..add(LoadTracksEvent()),
      ),
      BlocProvider(create: (_) => sl<PrivateChatMessagesCubit>())
    ], child: ChatListScreen()),
    BlocProvider(
      create: (_) => sl<UserFilterBloc>(),
      child: const SearchScreen(),
    ),
    MultiBlocProvider(providers: [
      // BlocProvider<MyProfileCubit>(
      //   create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
      // ),
      BlocProvider(create: (_) => sl<GetBookingsCubit>()),
      BlocProvider(create: (_) => sl<StatusBookBloc>()),
      BlocProvider(create: (_) => sl<SubmitReviewBloc>()),
    ], child: const SessionsScreen()),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
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
