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
  final Map<String, String> joinedChats = {};

  String? selectedChannel;
  String? selectedTrackId;

  @override
  void initState() {
    super.initState();
    context.read<TracksBloc>().add(LoadTracksEvent());
  }

  Future<void> _openChat(String chatId, String channel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatScreen(
              chatId: chatId,
              channelName: channel,
            ),
      ),
    );

    /// reload tracks when back
    context.read<TracksBloc>().add(LoadTracksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TracksBloc, TracksState>(
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Channels"),
        ),
        body: BlocBuilder<TracksBloc, TracksState>(
          builder: (context, state) {
            if (state is JoinTracksLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is JoinTracksLoaded) {
              final tracks = state.tracks;

              return ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];

                  final isJoined = joinedChats.containsKey(track.id);

                  return ListTile(
                    title: Text(track.name ?? ""),

                    subtitle: Text(
                      track.description ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    trailing: ElevatedButton(
                      onPressed: () {
                        selectedChannel = track.name;
                        selectedTrackId = track.id;

                        /// already joined
                        if (isJoined) {
                          _openChat(
                            joinedChats[track.id]!,
                            track.name!,
                          );
                          return;
                        }

                        /// join
                        context.read<TracksBloc>().add(
                          JoinTrackEvent(track.id!),
                        );
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

                      _openChat(
                        joinedChats[track.id]!,
                        track.name!,
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}