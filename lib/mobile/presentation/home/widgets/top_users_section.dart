import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../mobile/presentation/home/widgets/top_user_card.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/dependency_injection/injection.dart';

class TopUsersSection extends StatelessWidget {
  const TopUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true),
      child: const _TopUsersList(),
    );
  }
}

class _TopUsersList extends StatefulWidget {
  const _TopUsersList({super.key});

  @override
  State<_TopUsersList> createState() => _TopUsersListState();
}

class _TopUsersListState extends State<_TopUsersList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    final cubit = context.read<UsersCubit>();
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 150 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.18,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => const TopUserCard(isLoading: true),
            );
          }

          if (state is UsersLoaded) {
            return ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: state.isLastPage
                  ? state.users.length
                  : state.users.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index < state.users.length) {
                  final u = state.users[index];
                  return TopUserCard(
                    id: u.id,
                    image: u.userImage.secureUrl,
                    name: u.name,
                    track: u.track.name.isEmpty
                        ? "Mobile Development"
                        : u.track.name,
                    hours: u.helpTotalHours,
                  );
                } else {
                  // Loader عند نهاية القائمة
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
