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

    final usersData = await cubit.getLeaderboardUsers(page: 1);
    final userId = LocalStorage.getUserId();

    setState(() {
      users = usersData;
      myId = userId;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              LeaderBoardHeader(
                name: 'Leaderboard',
                onIcon1: () {
                  showStoreDialog(
                    context,
                    isFirstTime: false,
                    title: "Leaderboard",
                    subtitle: "leaderboard",
                  );
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
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.06),
                  topRight: Radius.circular(screenWidth * 0.06),
                ),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  _buildTableHeader(),

                  /// optional divider
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey.withOpacity(0.2),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final rank = index + 1;
                        final isMe = myId != null && user.id == myId;

                        return _buildItem(user, rank, isMe);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 HEADER (Rank | Player | Score)
Widget _buildTableHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            "RANK",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "PLAYER",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            "SCORE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 🔹 Rank Color
Color getRankColor(int rank) {
  if (rank == 1) return Colors.amber.shade700;
  if (rank == 2) return Colors.grey.shade500;
  if (rank == 3) return Colors.deepOrange.shade700;
  return AppPalette.primary;
}

Widget _buildItem(UserModel user, int rank, bool isMe) {
  final displayName = isMe ? "You" : user.name;
  final rankColor = getRankColor(rank);

  Gradient backgroundGradient;

  if (rank == 1) {
    backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFFFFD54F),
        Color(0xFFFFC107),
        Color(0xFFFFA000),
      ],
    );
  } else if (rank == 2) {
    backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFFE0E0E0),
        Color(0xFFB0BEC5),
        Color(0xFF90A4AE),
      ],
    );
  } else if (rank == 3) {
    backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFFFFB74D),
        Color(0xFFF57C00),
        Color(0xFFE65100),
      ],
    );
  } else {
    backgroundGradient =
    const LinearGradient(colors: [Colors.white, Colors.white]);
  }

  return AnimatedContainer(
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
        CircleAvatar(
          radius: rank <= 3 ? 30 : 22,
          backgroundColor: AppPalette.primary.withOpacity(0.15),
          backgroundImage: (user.userImage.secureUrl != null &&
              user.userImage.secureUrl!.isNotEmpty)
              ? NetworkImage(user.userImage.secureUrl!)
              : null,
          child: (user.userImage.secureUrl == null ||
              user.userImage.secureUrl!.isEmpty)
              ? Text(
            displayName[0],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: rank <= 3 ? 22 : 14,
              color: AppPalette.primary,
            ),
          )
              : null,
        ),

        const SizedBox(width: 14),

        /// Name
        Expanded(
          child: Text(
            displayName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: rank <= 3 ? 18 : 15,
              fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),

        if (rank <= 3)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.emoji_events,
              size: 30,
              color: rankColor,
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
  );
}

/// 🔹 Rank Badge
Widget _buildRankBadge(int rank) {
  final color = getRankColor(rank);

  return Container(
    width: rank <= 3 ? 52 : 44,
    height: rank <= 3 ? 52 : 44,
    decoration: BoxDecoration(
      color: color.withOpacity(0.25),
      borderRadius: BorderRadius.circular(14),
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
