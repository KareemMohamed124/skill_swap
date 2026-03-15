import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/prv_chat/prv_message_bubble.dart';

import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/common_ui/reply_preview_bar.dart';
import '../../../shared/common_ui/swipeable_message.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String partnerName;
  final String partnerId;
  final String? partnerImage;

  const PrivateChatScreen({
    super.key,
    required this.chatId,
    required this.partnerId,
    required this.partnerName,
    this.partnerImage,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  late PublicChatMessagesCubit _chatCubit;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _messageKeys = {};
  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<PublicChatMessagesCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _scrollToBottom() {
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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<PublicChatMessagesCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5, // Center the message
      );
      setState(() {
        _highlightedMessageId = messageId;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _highlightedMessageId = null;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message not available")),
      );
    }
  }

  void _showReplyOptions(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                _chatCubit.setReplyMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List messages) {
    final currentUserId = _chatCubit.currentUserId;

    return ListView.builder(
      controller: _scrollController,
      // reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final ChatMessage message = messages[index];
        final isMe = message.senderId.id == currentUserId;

        if (!_messageKeys.containsKey(message.id)) {
          _messageKeys[message.id] = GlobalKey();
        }

        return SwipeableMessage(
          onSwipeReply: () => _chatCubit.setReplyMessage(message),
          child: Container(
            key: _messageKeys[message.id],
            child: PrvMessageBubble(
              message: message,
              isMe: isMe,
              isHighlighted: _highlightedMessageId == message.id,
              onLongPress: () => _showReplyOptions(context, message),
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
      child: Column(
        children: [
          if (state is PublicChatMessagesLoaded && state.replyMessage != null)
            ReplyPreviewBar(
              replyMessage: state.replyMessage!,
              onCancel: () => _chatCubit.clearReply(),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
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
                  icon: Icon(Icons.send, color: AppPalette.primary),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppPalette.primary,
              backgroundImage:
                  widget.partnerImage != null && widget.partnerImage!.isNotEmpty
                      ? NetworkImage(widget.partnerImage!)
                      : null,
              child: widget.partnerImage == null || widget.partnerImage!.isEmpty
                  ? Text(
                      widget.partnerName.isNotEmpty
                          ? widget.partnerName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              widget.partnerName,
              style: const TextStyle(
                color: AppPalette.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                BlocConsumer<PublicChatMessagesCubit, PublicChatMessagesState>(
              listener: (context, state) {
                if (state is PublicChatMessagesLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is PublicChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PublicChatMessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    );
                  }
                  return _buildMessageList(state.messages);
                }

                if (state is PublicChatMessagesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to load messages'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context
                              .read<PublicChatMessagesCubit>()
                              .loadMessages(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          BlocBuilder<PublicChatMessagesCubit, PublicChatMessagesState>(
            builder: (context, state) {
              return _messageInput(state);
            },
          ),
        ],
      ),
    );
  }
}
