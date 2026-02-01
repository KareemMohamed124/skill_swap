import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';
import 'dart:math';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, String>> channels = [
    {"name": "General"},
    {"name": "React"},
    {"name": "UI/UX"},
  ];

  String? selectedChannel;

  final List<String> dummyUsers = [
    "Marvin",
    "Eleanor",
    "Jane",
    "Cody",
    "Floyd",
    "Alice",
    "Bob",
  ];
  final List<String> dummyMessages = [
    "Hello!",
    "How are you?",
    "Check this out",
    "Let's meet tomorrow",
    "I finished the task",
    "Great job!",
    "See you soon",
  ];

  String getRandomSubtitle() {
    final random = Random();
    final users = List.generate(
      3,
          (_) => dummyUsers[random.nextInt(dummyUsers.length)],
    );
    final message = dummyMessages[random.nextInt(dummyMessages.length)];
    return "${users.join(", ")}: $message";
  }

  String getRandomTime() {
    final random = Random();
    final hoursAgo = random.nextInt(24);
    if (hoursAgo == 0) return "now";
    return "$hoursAgo h ago";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "search".tr,
                prefixIcon: Icon(Icons.search, color: Theme.of(context).textTheme.bodyLarge!.color,),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.expand_more, color: Theme.of(context).textTheme.bodyLarge!.color,),
                SizedBox(width: 8),
                Text(
                  "channels".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  bool isSelected = channel["name"] == selectedChannel;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                      isSelected
                          ? (isDark ? Color(0xFF8F94FF) : Color(0xFFE6E7FF))
                          : Theme.of(context).cardColor,

                      border: Border.all(
                        color:
                        isSelected
                            ? Color(0xFF0D035F)
                            : Theme.of(context).dividerColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        isSelected
                            ? Color(0xFF0D035F)
                            : const Color(0XFFF2F5F8),
                        child: Text(
                          channel["name"]![0],
                          style: TextStyle(
                            color:
                            isSelected ? Colors.white : Color(0xFF0D035F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        channel["name"]!,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(getRandomSubtitle()),
                      trailing: Text(
                        getRandomTime(),
                        style: TextStyle(
                          fontSize: 12,
                         color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedChannel = channel["name"];
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                ChatScreen(channelName: channel["name"]!),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}