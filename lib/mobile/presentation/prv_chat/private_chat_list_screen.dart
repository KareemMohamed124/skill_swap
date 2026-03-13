import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/private_chat/private_chat_list_cubit.dart';
import '../../../shared/bloc/private_chat/private_chat_list_state.dart';
import '../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/chat/chat_models.dart';
import '../../../shared/dependency_injection/injection.dart';
import 'private_chat_screen.dart';

class PrivateChatListScreen extends StatelessWidget {
  const PrivateChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrivateChatListCubit>()..fetchChats(),
      child: const _PrivateChatListBody(),
    );
  }
}

class _PrivateChatListBody extends StatelessWidget {
  const _PrivateChatListBody();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Private Messages',
          style: TextStyle(
            color: AppPalette.primary,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: BlocBuilder<PrivateChatListCubit, PrivateChatListState>(
        builder: (context, state) {
          if (state is PrivateChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrivateChatListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load chats',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PrivateChatListCubit>().fetchChats(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PrivateChatListLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Text(
                  'No private chats yet',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<PrivateChatListCubit>().fetchChats(),
              child: ListView.builder(
                padding: EdgeInsets.all(screenWidth * 0.04),
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return _chatTile(context, chat, screenWidth, screenHeight);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _chatTile(BuildContext context, PrivateChatModel chat,
      double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppPalette.primary,
          backgroundImage:
              chat.partnerImage != null && chat.partnerImage!.isNotEmpty
                  ? NetworkImage(chat.partnerImage!)
                  : null,
          child: chat.partnerImage == null || chat.partnerImage!.isEmpty
              ? Text(
                  chat.partnerName.isNotEmpty
                      ? chat.partnerName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          chat.partnerName,
          style: TextStyle(
            fontWeight:
                chat.unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        subtitle: Text(
          chat.lastMessage ?? 'No messages yet',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontWeight:
                chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.lastMessageTime != null)
              Text(
                _formatTime(chat.lastMessageTime!),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            if (chat.unreadCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppPalette.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          // Mark as read
          context.read<PrivateChatListCubit>().markChatAsRead(chat.id);
          // Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<PrivateChatMessagesCubit>()
                  ..init(chat.id, partnerId: chat.partnerId),
                child: PrivateChatScreen(
                  chatId: chat.id,
                  partnerId: chat.partnerId,
                  partnerName: chat.partnerName,
                  partnerImage: chat.partnerImage,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${time.day}/${time.month}';
  }
}
