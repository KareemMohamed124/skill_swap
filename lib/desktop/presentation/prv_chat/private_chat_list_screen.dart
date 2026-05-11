import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/private_chat/private_chat_list_cubit.dart';
import '../../../shared/bloc/private_chat/private_chat_list_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/chat/chat_models.dart';
import '../../../shared/dependency_injection/injection.dart';

class PrivateChatListDesktop extends StatelessWidget {
  final Function(String chatId, String partnerName, String? partnerImage)?
      onChatSelected;

  const PrivateChatListDesktop({super.key, this.onChatSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrivateChatListCubit>()..fetchChats(),
      child: _PrivateChatListBody(onChatSelected: onChatSelected),
    );
  }
}

class _PrivateChatListBody extends StatelessWidget {
  final Function(String chatId, String partnerName, String? partnerImage)?
      onChatSelected;

  const _PrivateChatListBody({this.onChatSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Private Messages',
              style: TextStyle(
                color: AppPalette.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<PrivateChatListCubit, PrivateChatListState>(
                builder: (context, state) {
                  if (state is PrivateChatListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PrivateChatListError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Failed to load chats'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context
                                .read<PrivateChatListCubit>()
                                .fetchChats(),
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
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return _chatTile(context, chat);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatTile(BuildContext context, PrivateChatModel chat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
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
          context.read<PrivateChatListCubit>().markChatAsRead(chat.id);
          onChatSelected?.call(chat.id, chat.partnerName, chat.partnerImage);
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
