import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../pages/next_session_view_all.dart';
import 'next_session_card.dart';
import 'section_header.dart';

class NextSessionSection extends StatelessWidget {
  const NextSessionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetTodaySessionsLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppPalette.primary,
          ));
        }

        if (state is GetTodaySessionsLoaded) {
          if (state.sessions.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                sectionTitle: 'your_next_session'.tr,
                onTop: () {
<<<<<<< HEAD
                  Get.to(
                    () => BlocProvider.value(
                      value: context.read<GetBookingsCubit>(),
                      child: const NextSessionViewAll(),
                    ),
                  );
                },
              ),
              //  const SizedBox(height: 10),
=======
                  Get.to(NextSessionViewAll());
                },
              ),
              const SizedBox(height: 10),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.sessions.length,
<<<<<<< HEAD
                separatorBuilder: (_, __) => const SizedBox(height: 8),
=======
                separatorBuilder: (_, __) => const SizedBox(height: 10),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                itemBuilder: (context, index) {
                  final s = state.sessions[index];

                  return NextSessionCard(
                    name: s.name,
                    duration: s.duration,
                    dateTime: s.dateTime,
<<<<<<< HEAD
                    sessionTime: s.sessionTime,
                    isMentor: s.isMentor,
=======
                    startsIn: s.startsIn,
                    isMentor: s.isMentor,
                    remainingMinutes: s.remainingMinutes,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  );
                },
              ),
            ],
          );
        }

        if (state is GetBookingsError) {
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
