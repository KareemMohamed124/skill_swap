import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/main.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
=======
import 'package:skill_swap/main.dart';
import '../../../../shared/constants/strings.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../widgets/next_session_card.dart';

class NextSessionViewAll extends StatefulWidget {
  const NextSessionViewAll({super.key});

  @override
  State<NextSessionViewAll> createState() => _NextSessionViewAllState();
}

class _NextSessionViewAllState extends State<NextSessionViewAll> {
  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
<<<<<<< HEAD
          /// HEADER (زي ما هو)
=======
          // Header
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade800, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final didGoBack = desktopKey.currentState?.goBack();
<<<<<<< HEAD
                    if (didGoBack == false) {
                      desktopKey.currentState?.openPage(index: 0);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).textTheme.bodySmall!.color,
=======
                    if(didGoBack == false) {
                      desktopKey.currentState?.openPage(index: 0);
                    }
                  },
                  icon:  Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodySmall!.color,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Next Sessions",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

<<<<<<< HEAD
          /// BODY (هنا اللوجيك الجديد)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<GetBookingsCubit, GetBookingsState>(
                builder: (context, state) {
                  /// 🔄 Loading
                  if (state is GetTodaySessionsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppPalette.primary,
                      ),
                    );
                  }

                  /// ✅ Success
                  if (state is GetTodaySessionsLoaded) {
                    if (state.sessions.isEmpty) {
                      return const Center(
                        child: Text("No sessions available"),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.sessions.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: screenHeight * 0.02),
                      itemBuilder: (context, index) {
                        final s = state.sessions[index];

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: NextSessionCard(
                              name: s.name,
                              duration: s.duration,
                              dateTime: s.dateTime,
                              sessionTime: s.sessionTime,
                              isMentor: s.isMentor,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  /// ❌ Error
                  if (state is GetBookingsError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }

                  return const SizedBox.shrink();
=======
          // List of sessions
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView.separated(
                itemCount: AppData.nextSessions.length,
                scrollDirection: Axis.vertical,
                separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.02),
                itemBuilder: (context, index) {
                  final session = AppData.nextSessions[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: NextSessionCard(
                        name: session.name,
                        duration: session.duration,
                        dateTime: session.dateTime,
                        startsIn: session.startsIn,
                        isMentor: session.isMentor,
                      ),
                    ),
                  );
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
