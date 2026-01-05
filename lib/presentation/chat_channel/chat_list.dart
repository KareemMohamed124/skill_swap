import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: Color(0xFF0D035F)),
                filled: true,
                fillColor: Color(0XFFF2F5F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.expand_more, color: Color(0xFF0D035F)),
                SizedBox(width: 8),
                Text(
                  "Channels",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0D035F),
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
                          ? const Color(0xFFE6E7FF)
                          : const Color.fromARGB(255, 255, 255, 255),

                      border: Border.all(
                        color:
                        isSelected
                            ? Color(0xFF0D035F)
                            : const Color(0XFFF2F5F8),
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
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