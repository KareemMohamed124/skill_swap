import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/sessions/widgets/session_card.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';

class UpcomingSessionsPage extends StatelessWidget {
  const UpcomingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetBookingsLoading) {
          return Center(
              child: CircularProgressIndicator(
            color: AppPalette.primary,
          ));
        }

        if (state is GetBookingsError) {
          return Center(child: Text(state.message));
        }

        if (state is GetBookingsLoaded) {
          if (state.bookings.isEmpty) {
            return const Center(child: Text("No upcoming sessions"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Payment Required",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "You have sessions that require payment.\nComplete payment to secure your booking.",
                              style: TextStyle(
                                //  color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.bookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      return SessionCard(
                        session: state.bookings[index],
                        currentStatus: "accepted",
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
