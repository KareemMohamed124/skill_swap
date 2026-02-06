import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_screen.dart';

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
    /// ✅ MediaQuery
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "search".tr,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                children: [
                  Icon(
                    Icons.expand_more,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  const SizedBox(width: 8),
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
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    bool isSelected = channel["name"] == selectedChannel;

                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.007),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                ? const Color(0xFF8F94FF)
                                : const Color(0xFFE6E7FF))
                            : Theme.of(context).cardColor,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0D035F)
                              : Theme.of(context).dividerColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? const Color(0xFF0D035F)
                              : const Color(0XFFF2F5F8),
                          child: Text(
                            channel["name"]![0],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF0D035F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          channel["name"]!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(getRandomSubtitle()),
                        trailing: Text(
                          getRandomTime(),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedChannel = channel["name"];
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
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
      ),
    );
  }
}
