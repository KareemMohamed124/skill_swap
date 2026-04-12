import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/common_ui/swipeable_message.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';
import '../../../shared/dependency_injection/injection.dart';
import 'message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String channelName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.channelName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PublicChatMessagesCubit _chatCubit;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _messageKeys = {};

  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _chatCubit = sl<PublicChatMessagesCubit>();
    _chatCubit.init(widget.chatId, isPrivate: false);
  }

  /// ✅ يسمح بالتعديل لمدة 15 دقيقة فقط
  bool _canEditMessage(ChatMessage message) {
    final difference = DateTime.now().difference(message.createdAt);
    return difference.inMinutes <= 15;
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final state = _chatCubit.state;

    if (state is PublicChatMessagesLoaded && state.editingMessage != null) {
      _chatCubit.editMessage(state.editingMessage!.id, text);
      _chatCubit.clearEditing();
    } else {
      _chatCubit.sendMessage(text);
    }

    _controller.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
      );

      setState(() => _highlightedMessageId = messageId);

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _highlightedMessageId = null);
        }
      });
    }
  }

  /// ✅ Message Options بعد التعديل
  void _showMessageOptions(BuildContext context, ChatMessage message) {
    final isMe = message.senderId.id == _chatCubit.currentUserId;

    final canEdit = _canEditMessage(message);

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                _chatCubit.setReplyMessage(message);
                Navigator.pop(context);
              },
            ),

            /// Edit يظهر فقط قبل 15 دقيقة
            if (isMe && canEdit)
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);

                  _chatCubit.setEditingMessage(message);

                  _controller.text = message.content;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: message.content.length),
                  );
                },
              ),

            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, message);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ChatMessage message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _chatCubit.deleteMessage(message.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId.id == _chatCubit.currentUserId;

        _messageKeys.putIfAbsent(message.id, () => GlobalKey());

        return SwipeableMessage(
          onSwipeReply: () => _chatCubit.setReplyMessage(message),
          child: Container(
            key: _messageKeys[message.id],
            child: MessageBubble(
              message: message,
              isMe: isMe,
              senderName: message.senderId.name ?? "User",
              senderImage: message.senderId.userImage.secureUrl,
              showAvatar: true,
              showName: true,
              isHighlighted: _highlightedMessageId == message.id,
              onLongPress: () => _showMessageOptions(context, message),
              onTapReply: message.replyTo != null
                  ? () => _scrollToMessage(message.replyTo!.id)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _messageInput(PublicChatMessagesState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Message...",
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.send, color: AppPalette.primary),
              onPressed: _sendMessage,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatCubit.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: Text(widget.channelName),
        ),
        body: BlocBuilder<PublicChatMessagesCubit, PublicChatMessagesState>(
          builder: (context, state) {
            if (state is PublicChatMessagesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final messages = state is PublicChatMessagesLoaded
                ? state.messages
                : <ChatMessage>[];

            return Column(
              children: [
                Expanded(child: _buildMessageList(messages)),
                _messageInput(state),
              ],
            );
          },
        ),
      ),
    );
  }
}
