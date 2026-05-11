<<<<<<< HEAD
import 'dart:async';

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
<<<<<<< HEAD
import '../widgets/session_card.dart';

class RequestsSessionsPage extends StatefulWidget {
  const RequestsSessionsPage({super.key});

  @override
  State<RequestsSessionsPage> createState() => _RequestsSessionsPageState();
}

class _RequestsSessionsPageState extends State<RequestsSessionsPage> {
  
  @override
=======
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/session_card.dart';

class RequestsSessionsPage extends StatelessWidget {
  const RequestsSessionsPage({super.key});

  @override
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetBookingsLoading) {
<<<<<<< HEAD
          return const Center(child: CircularProgressIndicator());
=======
          return const Center(
              child: CircularProgressIndicator(
            color: AppPalette.primary,
          ));
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        }

        if (state is GetBookingsError) {
          return Center(child: Text(state.message));
        }

        if (state is GetBookingsLoaded) {
          final requests =
<<<<<<< HEAD
          state.bookings.where((s) => s.rawStatus == "requested").toList();
=======
              state.bookings.where((s) => s.rawStatus == "requested").toList();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

          if (requests.isEmpty) {
            return const Center(child: Text("No requests"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              return SessionCard(
<<<<<<< HEAD
                session: requests[index],
                currentStatus: "pending",
              );
=======
                  session: requests[index], currentStatus: "pending");
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
