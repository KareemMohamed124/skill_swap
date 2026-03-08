import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../shared/bloc/tracks_bloc/tracks_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? selectedChannel;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<TracksBloc, TracksState>(
      listener: (context, state) {
        if (state is JoinTrackSuccess) {
          Get.snackbar(
            "Success",
            state.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        if (state is TracksError) {
          Get.snackbar(
            "Error",
            state.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Scaffold(
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
                /// Search
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

                /// Channels title
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

                /// Tracks List
                Expanded(
                  child: BlocBuilder<TracksBloc, TracksState>(
                    builder: (context, state) {
                      if (state is TracksLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is TracksError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is TracksLoaded) {
                        final tracks = state.tracks;

                        return ListView.builder(
                          itemCount: tracks.length,
                          itemBuilder: (context, index) {
                            final track = tracks[index];
                            bool isSelected = track.name == selectedChannel;

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.007),
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
                                      ? AppPalette.primary
                                      : Theme.of(context).dividerColor,
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: ListTile(
                                /// Avatar
                                leading: CircleAvatar(
                                  backgroundColor: isSelected
                                      ? AppPalette.primary
                                      : const Color(0XFFF2F5F8),
                                  child: Text(
                                    track.name![0],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppPalette.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                /// Channel Name
                                title: Text(
                                  track.name ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),

                                /// Description
                                subtitle: Text(
                                  track.description ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                /// Join Button
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppPalette.primary,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<TracksBloc>()
                                        .add(JoinTrackEvent(track.id!));
                                  },
                                  child: const Text(
                                    "Join",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),

                                /// Open Chat
                                onTap: () {
                                  setState(() {
                                    selectedChannel = track.name;
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        chatId: track.id!,
                                        channelName: track.name!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
