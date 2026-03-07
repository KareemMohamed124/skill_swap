import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../../../../main.dart';
import '../../prv_chat/private_chat_list_screen.dart';
import '../../prv_chat/private_chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../../shared/dependency_injection/injection.dart';

class ChatListScreen extends StatefulWidget {
  final Function(String)? onChannelSelected;
  final String? selectedChannel;

  const ChatListScreen({
    super.key,
    this.onChannelSelected,
    this.selectedChannel,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, String>> channels = [
    {"name": "General"},
    {"name": "React"},
    {"name": "UI/UX"},
  ];

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Private Messages Button
            InkWell(
              onTap: () {
                desktopKey.currentState?.openSidePage(
                  body: PrivateChatListDesktop(
                    onChatSelected: (chatId, partnerName, partnerImage) {
                      desktopKey.currentState?.openSidePage(
                        body: PrivateChatListDesktop(
                          onChatSelected:
                              (chatId, partnerName, partnerImage) {},
                        ),
                        rightPanel: BlocProvider(
                          create: (_) =>
                              sl<PrivateChatMessagesCubit>()..init(chatId),
                          child: PrivateChatScreen(
                            chatId: chatId,
                            partnerName: partnerName,
                            partnerImage: partnerImage,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFE6E7FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0D035F),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Color(0xFF0D035F)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Private Messages',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0D035F),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Color(0xFF0D035F)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.expand_more,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
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
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  bool isSelected = channel["name"] == widget.selectedChannel;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      borderRadius: BorderRadius.circular(12),
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
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      onTap: () {
                        widget.onChannelSelected?.call(channel["name"]!);
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
