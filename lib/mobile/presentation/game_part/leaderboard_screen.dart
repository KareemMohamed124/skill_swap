import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../shared/data/models/user/user_model.dart';
import '../../../shared/helper/local_storage.dart';
import '../game_stor/widgets/show_store_daiolg.dart';
import 'leaderboard_header.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<UserModel> users = [];
  bool isLoading = true;
  String? myId;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    final cubit = context.read<UsersCubit>();

    final results = await Future.wait([
      cubit.getLeaderboardUsers(page: 1),
      LocalStorage.getUserId(),
    ]);

    setState(() {
      users = results[0] as List<UserModel>;
      myId = results[1] as String?;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              LeaderBoardHeader(
                name: 'Leaderboard',
                onIcon1: () {
                  showStoreDialog(context,
                      isFirstTime: false,
                      title: "Leaderboard",
                      subtitle: "leaderboard");
                },
              )
            ],
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.85),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.06),
                  topRight: Radius.circular(screenWidth * 0.06),
                ),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final rank = index + 1;
                        final isMe = myId != null && user.id == myId;

                        return _buildItem(user, rank, isMe);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildItem(UserModel user, int rank, bool isMe) {
  final displayName = isMe ? "You" : user.name;

  Gradient backgroundGradient;

  if (rank == 1) {
    backgroundGradient = const LinearGradient(
      colors: [Colors.amber, Colors.yellowAccent],
    );
  } else if (rank == 2) {
    backgroundGradient = LinearGradient(
      colors: [Colors.grey.shade400, Colors.grey.shade200],
    );
  } else if (rank == 3) {
    backgroundGradient = LinearGradient(
      colors: [Colors.deepOrangeAccent, Colors.orangeAccent],
    );
  } else {
    backgroundGradient = const LinearGradient(
      colors: [Colors.white, Colors.white],
    );
  }

  return AnimatedScale(
    scale: 1.0,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
        border: isMe ? Border.all(color: AppPalette.primary, width: 2) : null,
      ),
      child: Row(
        children: [
          _buildRankBadge(rank),
          const SizedBox(width: 14),

          /// Avatar
          Container(
            decoration: isMe
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.primary.withOpacity(0.35),
                        blurRadius: 12,
                      )
                    ],
                  )
                : rank <= 3
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: rank == 3
                                ? Colors.deepOrange.shade200.withOpacity(0.6)
                                : Colors.amber
                                    .withOpacity(0.4), // glow قوي للتالت
                            blurRadius: 22,
                            spreadRadius: 2,
                          )
                        ],
                      )
                    : null,
            child: CircleAvatar(
              radius: rank <= 3 ? 30 : 22,
              backgroundColor: AppPalette.primary.withOpacity(0.15),
              backgroundImage: (user.userImage.secureUrl != null &&
                      user.userImage.secureUrl!.isNotEmpty)
                  ? NetworkImage(user.userImage.secureUrl!)
                  : null,
              child: (user.userImage.secureUrl == null ||
                      user.userImage.secureUrl!.isEmpty)
                  ? Text(
                      displayName[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: rank <= 3 ? 22 : 14,
                        color: AppPalette.primary,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          /// Name + Trophy
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: rank <= 3 ? 18 : 15,
                          fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Score player",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (rank <= 3)
                  Icon(
                    Icons.emoji_events,
                    color: rank == 1
                        ? Colors.amber.shade700
                        : rank == 2
                            ? Colors.grey.shade500
                            : Colors.deepOrangeAccent,
                    size: 32,
                  ),
              ],
            ),
          ),

          /// Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppPalette.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              user.totalScore.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppPalette.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildRankBadge(int rank) {
  Color color;

  if (rank == 1) {
    color = Colors.amber.shade700;
  } else if (rank == 2) {
    color = Colors.grey.shade500;
  } else if (rank == 3) {
    color = Colors.deepOrange.shade700;
  } else {
    color = AppPalette.primary;
  }

  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    width: rank <= 3 ? 52 : 44,
    height: rank <= 3 ? 52 : 44,
    decoration: BoxDecoration(
      color: color.withOpacity(0.25),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(rank <= 3 ? 0.6 : 0.3),
          blurRadius: rank <= 3 ? 14 : 8,
          offset: const Offset(0, 4),
        )
      ],
      gradient: rank <= 3
          ? LinearGradient(
              colors: [color.withOpacity(0.5), color.withOpacity(0.2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
    ),
    alignment: Alignment.center,
    child: Text(
      rank.toString(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
        fontSize: rank <= 3 ? 20 : 16,
      ),
    ),
  );
}
