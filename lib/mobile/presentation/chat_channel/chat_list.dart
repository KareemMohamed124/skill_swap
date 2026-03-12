import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/public_chat/public_chat_bloc.dart';
import '../../../shared/bloc/public_chat/public_chat_event.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_state.dart';
import '../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../shared/bloc/tracks_bloc/tracks_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../../../shared/helper/local_storage.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final Map<String, String> joinedChats = {}; // trackId -> chatId
  String? selectedChannel;
  String? selectedTrackId;
  String searchQuery = "";
  String? currentUserId;

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

  Future<void> _openChat(String chatId, String channel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<PublicChatMessagesCubit>()),
              ],
              child: ChatScreen(chatId: chatId, channelName: channel),
            ),
      ),
    );
    context.read<TracksBloc>().add(LoadTracksEvent());
    context.read<PublicChatBloc>().add(GetPublicChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<TracksBloc, TracksState>(
          listener: (context, state) {
            if (state is JoinTracksSuccess) {
              final chatId = state.success.success.chatDetails.id;

              setState(() {
                joinedChats[selectedTrackId!] = chatId;
              });

              _openChat(chatId, selectedChannel!);
            }

            if (state is JoinTracksError) {
              Get.snackbar(
                "Error",
                state.error.error.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text("Channels"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [

                /// Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search".tr,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge!
                          .color,
                    ),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),

                /// Channels list
                Expanded(
                  child: BlocBuilder<TracksBloc, TracksState>(
                    builder: (context, trackState) {
                      if (trackState is JoinTracksLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (trackState is JoinTracksLoaded) {
                        final tracks = trackState.tracks;
                        final publicChatState =
                            context
                                .watch<PublicChatBloc>()
                                .state;
                        final publicChats = publicChatState is PublicChatsLoaded
                            ? publicChatState.chats.chats
                            : <dynamic>[];

                        // Apply search filter
                        final filteredTracks = tracks
                            .where((track) =>
                            track.name!.toLowerCase().contains(searchQuery))
                            .toList();

                        return ListView.builder(
                          itemCount: filteredTracks.length,
                          itemBuilder: (context, index) {
                            final track = filteredTracks[index];

                            // Find the chat for this track
                            final chat =
                            publicChats.cast<dynamic?>().firstWhere(
                                  (c) =>
                              c != null && c.trackId?._id == track.id,
                              orElse: () => null,
                            );

                            // Determine if user joined
                            bool isJoined = false;
                            String? chatId;

                            if (chat != null) {
                              final isParticipant = chat.participants.any(
                                    (p) =>
                                p._id == currentUserId,
                              );

                              if (isParticipant) {
                                isJoined = true;
                                chatId = chat._id;
                              }
                            }

                            // Check local joined map
                            if (joinedChats.containsKey(track.id)) {
                              isJoined = true;
                              chatId = joinedChats[track.id];
                            }

                            final isSelected = track.name == selectedChannel;

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
                                    : Theme
                                    .of(context)
                                    .cardColor,
                                border: Border.all(
                                  color: isSelected
                                      ? AppPalette.primary
                                      : Theme
                                      .of(context)
                                      .dividerColor,
                                  width: 2,
                                ),
                                borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: ListTile(
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
                                title: Text(track.name ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  track.description ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    selectedChannel = track.name;
                                    selectedTrackId = track.id;

                                    if (isJoined && chatId != null) {
                                      _openChat(chatId, track.name!);
                                      return;
                                    }

                                    context
                                        .read<TracksBloc>()
                                        .add(JoinTrackEvent(track.id!));
                                  },
                                  child: Text(isJoined ? "Joined" : "Join"),
                                ),
                                onTap: () {
                                  if (!isJoined || chatId == null) {
                                    Get.snackbar(
                                      "Warning",
                                      "You must join this channel first",
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  _openChat(chatId, track.name!);
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
