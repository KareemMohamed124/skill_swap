import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../../shared/bloc/tracks_bloc/tracks_state.dart';

class ChatListScreen extends StatefulWidget {
  final Function(String chatId, String channelName)? onChannelSelected;
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
  final Map<String, String> joinedChats = {};
  String? selectedTrackId;
  String? selectedChannel;

  @override
  void initState() {
    super.initState();
    context.read<TracksBloc>().add(LoadTracksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<TracksBloc, TracksState>(
      listener: (context, state) {
        if (state is JoinTracksSuccess) {
          final chatId = state.success.success.chatDetails.id;
          setState(() {
            joinedChats[selectedTrackId!] = chatId;
          });

          widget.onChannelSelected?.call(chatId, selectedChannel!);
        }

        if (state is JoinTracksError) {
          Get.snackbar(
            "Error",
            state.error.error.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Scaffold(
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
              const SizedBox(height: 20),
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
                child: BlocBuilder<TracksBloc, TracksState>(
                  builder: (context, state) {
                    if (state is JoinTracksLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is JoinTracksLoaded) {
                      final tracks = state.tracks;

                      if (tracks.isEmpty) {
                        return Center(
                          child: Text(
                            'No channels available',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          final isJoined = joinedChats.containsKey(track.id);
                          final bool isSelected =
                              track.name == widget.selectedChannel;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
                                  (track.name ?? '?')[0],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0D035F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                track.name ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                track.description ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  selectedChannel = track.name;
                                  selectedTrackId = track.id;

                                  if (isJoined) {
                                    widget.onChannelSelected?.call(
                                      joinedChats[track.id]!,
                                      track.name!,
                                    );
                                    return;
                                  }

                                  context
                                      .read<TracksBloc>()
                                      .add(JoinTrackEvent(track.id!));
                                },
                                child: Text(isJoined ? "Joined" : "Join"),
                              ),
                              onTap: () {
                                if (!isJoined) {
                                  Get.snackbar(
                                    "Warning",
                                    "You must join this channel first",
                                  );
                                  return;
                                }

                                widget.onChannelSelected?.call(
                                  joinedChats[track.id]!,
                                  track.name!,
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
    );
  }
}
