import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const Color primaryColor = Color(0xFF3F51B5);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> players = [
      {"rank": 1, "name": "Alice", "score": 9800},
      {"rank": 2, "name": "Bob", "score": 8700},
      {"rank": 3, "name": "Charlie", "score": 8500},
      {"rank": 4, "name": "You", "score": 8200, "isMe": true},
      {"rank": 5, "name": "Dave", "score": 7800},
      {"rank": 6, "name": "Eve", "score": 7500},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          final bool isMe = player["isMe"] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isMe
                  ? primaryColor.withOpacity(0.12)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
              border: isMe ? Border.all(color: primaryColor, width: 1.5) : null,
            ),
            child: Row(
              children: [
                _buildRankBadge(player["rank"]),
                const SizedBox(width: 16),

                /// Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Text(
                    player["name"][0],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),

                const SizedBox(width: 16),

                /// Name
                Expanded(
                  child: Text(
                    player["name"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                /// Score
                Text(
                  player["score"].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;

    if (rank == 1) {
      badgeColor = Colors.amber;
    } else if (rank == 2) {
      badgeColor = Colors.grey;
    } else if (rank == 3) {
      badgeColor = Colors.deepOrange;
    } else {
      badgeColor = primaryColor;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        rank.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }
}
