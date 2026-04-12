import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/next_session_card.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';

class NextSessionSectionDesktop extends StatelessWidget {
  const NextSessionSectionDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetTodaySessionsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetTodaySessionsLoaded) {
          if (state.sessions.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final s = state.sessions[i];

              return NextSessionCard(
                name: s.name,
                duration: s.duration,
                dateTime: s.dateTime,
                sessionTime: s.sessionTime,
                isMentor: s.isMentor,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
