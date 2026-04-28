import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../../shared/common_ui/swipeable_message.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/public_chat/get_history_messages.dart';
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

  bool _didInitialScroll = false;

  @override
  void initState() {
    super.initState();

    _chatCubit = context.read<PublicChatMessagesCubit>();

    _chatCubit.init(
      widget.chatId,
      isPrivate: false,
    );
  }

  // ================= SEND =================
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
    _scrollToBottom();
  }

  // ================= SCROLL =================
  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // 🔥 scroll مرة واحدة فقط بعد تحميل الرسائل
  void _handleInitialScroll() {
    if (_didInitialScroll) return;

    _didInitialScroll = true;

    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollToBottom();
    });
  }

  // ================= MESSAGE SCROLL =================
  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key?.currentContext == null) return;

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 300),
      alignment: 0.5,
    );

    setState(() => _highlightedMessageId = messageId);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _highlightedMessageId = null);
    });
  }

  // ================= BUILD LIST =================
  Widget _buildMessages(List<ChatMessage> messages) {
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
              onLongPress: () {},
              onTapReply: message.replyTo != null
                  ? () => _scrollToMessage(message.replyTo!.id)
                  : null,
            ),
          ),
        );
      },
    );
  }

  // ================= INPUT =================
  Widget _messageInput(PublicChatMessagesState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Message...",
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
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
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicChatMessagesCubit, PublicChatMessagesState>(
      builder: (context, state) {
        final messages = state is PublicChatMessagesLoaded
            ? state.messages
            : <ChatMessage>[];

        // 🔥 أول تحميل بس يعمل scroll
        if (state is PublicChatMessagesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleInitialScroll();
          });
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            title: Text(widget.channelName),
          ),
          body: Column(
            children: [
              Expanded(child: _buildMessages(messages)),
              _messageInput(state),
            ],
          ),
        );
      },
    );
  }
}
