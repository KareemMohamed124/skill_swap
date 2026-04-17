import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/public_chat/public_chat_bloc.dart';
import '../../../../shared/bloc/public_chat/public_chat_event.dart';
import '../../../../shared/bloc/public_chat/public_chat_state.dart';
import '../../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../../shared/bloc/tracks_bloc/tracks_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/public_chat/get_chat_model.dart';
import '../../../../shared/helper/local_storage.dart';

class ChatListScreen extends StatefulWidget {
  final Function(String chatId, String channelName)? onChannelSelected;

  const ChatListScreen({super.key, this.onChannelSelected});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final Map<String, String> joinedChats = {};
  final Set<String> _leavingTracks = {};
  final Set<String> _joiningTracks = {};

  String? selectedChannel;
  String? selectedTrackId;
  String searchQuery = "";
  String? currentUserId;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUser();

    context.read<TracksBloc>().add(LoadTracksEvent());
    context.read<PublicChatBloc>().add(GetPublicChatsEvent());
  }

  Future<void> _loadUser() async {
    currentUserId = await LocalStorage.getUserId();
    setState(() {});
  }

  void _openChat(String chatId, String channel) {
    widget.onChannelSelected?.call(chatId, channel);
  }

  void _showLeaveConfirmation(
      String chatId, String channelName, String trackId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Channel'),
        content: Text('Are you sure you want to leave "$channelName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _leavingTracks.add(trackId));
              context.read<TracksBloc>().add(LeaveChatEvent(chatId));
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<TracksBloc, TracksState>(
          listener: (context, state) {
            if (state is JoinTracksSuccess) {
              final chatId = state.success.success.chatDetails.id;

              setState(() {
                _joiningTracks.remove(selectedTrackId);
                joinedChats[selectedTrackId!] = chatId;
              });

              widget.onChannelSelected?.call(chatId, selectedChannel!);
            }

            if (state is JoinTracksError) {
              setState(() => _joiningTracks.remove(selectedTrackId));

              Get.snackbar(
                "Error",
                state.error.error.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }

            if (state is LeaveChatSuccess) {
              setState(() {
                _leavingTracks.remove(selectedTrackId);
                joinedChats.remove(selectedTrackId);
              });

              Get.snackbar(
                "Success",
                "You left the channel successfully",
                snackPosition: SnackPosition.BOTTOM,
              );

              context.read<PublicChatBloc>().add(GetPublicChatsEvent());
            }

            if (state is LeaveChatError) {
              setState(() => _leavingTracks.remove(selectedTrackId));

              Get.snackbar(
                "Error",
                state.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }

            if (state is JoinTracksLoaded) {
              _dataLoaded = true;
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// SEARCH
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search".tr,
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// LIST
                    Expanded(
                      child: BlocBuilder<TracksBloc, TracksState>(
                        builder: (context, trackState) {
                          if (trackState is JoinTracksLoading && !_dataLoaded) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (trackState is JoinTracksLoaded) {
                            final tracks = trackState.tracks;

                            final publicChatState =
                                context.watch<PublicChatBloc>().state;

                            final publicChats =
                                publicChatState is PublicChatsLoaded
                                    ? publicChatState.chats.chats
                                    : <dynamic>[];

                            final filteredTracks = tracks
                                .where((track) => track.name!
                                    .toLowerCase()
                                    .contains(searchQuery))
                                .toList();

                            return ListView.builder(
                              itemCount: filteredTracks.length,
                              itemBuilder: (context, index) {
                                final track = filteredTracks[index];

                                final chat = publicChats
                                    .cast<GetChatModel?>()
                                    .firstWhere(
                                      (c) =>
                                          c != null && c.track?.id == track.id,
                                      orElse: () => null,
                                    );

                                bool isJoined =
                                    chat?.isJoined(currentUserId ?? "") ??
                                        false;

                                String? chatId = chat?.id;

                                if (joinedChats.containsKey(track.id)) {
                                  isJoined = true;
                                  chatId = joinedChats[track.id];
                                }

                                final isSelected =
                                    track.name == selectedChannel;

                                final isLeaving =
                                    _leavingTracks.contains(track.id);

                                final isJoining =
                                    _joiningTracks.contains(track.id);

                                return InkWell(
                                  onTap: () {
                                    if (!isJoined) {
                                      Get.snackbar(
                                        "Oops",
                                        "You need to join first",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                      return;
                                    }

                                    if (chatId != null) {
                                      selectedChannel = track.name;
                                      selectedTrackId = track.id;
                                      _openChat(chatId, track.name!);
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (isDark
                                              ? AppPalette.primary
                                                  .withValues(alpha: 0.5)
                                              : const Color(0xFFE6E7FF))
                                          : Theme.of(context).cardColor,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppPalette.primary
                                            : Theme.of(context).dividerColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 22,
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
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          track.name ?? "",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      if (!isJoined)
                                                        ElevatedButton(
                                                          onPressed: isJoining
                                                              ? null
                                                              : () {
                                                                  selectedChannel =
                                                                      track
                                                                          .name;
                                                                  selectedTrackId =
                                                                      track.id;

                                                                  setState(() =>
                                                                      _joiningTracks
                                                                          .add(track
                                                                              .id!));

                                                                  context
                                                                      .read<
                                                                          TracksBloc>()
                                                                      .add(
                                                                        JoinTrackEvent(
                                                                            track.id!),
                                                                      );
                                                                },
                                                          child: isJoining
                                                              ? const SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : const Text(
                                                                  "Join"),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(track.description ?? ""),
                                                  if (isJoined &&
                                                      chatId != null) ...[
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            selectedChannel =
                                                                track.name;
                                                            selectedTrackId =
                                                                track.id;
                                                            _openChat(chatId!,
                                                                track.name!);
                                                          },
                                                          child: const Text(
                                                              "Open"),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        OutlinedButton(
                                                          onPressed: isLeaving
                                                              ? null
                                                              : () {
                                                                  selectedChannel =
                                                                      track
                                                                          .name;
                                                                  selectedTrackId =
                                                                      track.id;

                                                                  _showLeaveConfirmation(
                                                                    chatId!,
                                                                    track.name!,
                                                                    track.id!,
                                                                  );
                                                                },
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.red,
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          child: isLeaving
                                                              ? const SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              : const Text(
                                                                  "Leave"),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
        ),
      ),
    );
  }
}
