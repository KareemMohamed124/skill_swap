<<<<<<< HEAD
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/prv_chat/prv_message_bubble.dart';

import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/public_chat/message_search_cubit.dart';
import '../../../shared/bloc/public_chat/message_search_state.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/common_ui/edit_preview_bar.dart';
import '../../../shared/common_ui/reply_preview_bar.dart';
import '../../../shared/common_ui/swipeable_message.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../chat_channel/chat_theme_page.dart';
=======
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../shared/bloc/private_chat/private_chat_messages_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/chat/chat_models.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String partnerName;
<<<<<<< HEAD
  final String partnerId;
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final String? partnerImage;

  const PrivateChatScreen({
    super.key,
    required this.chatId,
<<<<<<< HEAD
    required this.partnerId,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    required this.partnerName,
    this.partnerImage,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
<<<<<<< HEAD
  late PublicChatMessagesCubit _chatCubit;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _messageKeys = {};
  String? _highlightedMessageId;
  late MessageSearchCubit _searchCubit;

  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  Timer? _debounce;
=======
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _chatCubit = context.read<PublicChatMessagesCubit>();
    _searchCubit = sl<MessageSearchCubit>();
=======
    _scrollController.addListener(_onScroll);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _debounce?.cancel();
    _searchCubit.close();
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    // _chatCubit.close();
    super.dispose();
  }

=======
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when scrolled near the top (for older messages)
    if (_scrollController.hasClients &&
        _scrollController.position.pixels <=
            _scrollController.position.minScrollExtent + 100) {
      context.read<PrivateChatMessagesCubit>().loadMore();
    }
  }

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
<<<<<<< HEAD
          _scrollController.position.minScrollExtent,
          // ✅ reverse: true فـ min مش max
=======
          _scrollController.position.maxScrollExtent,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
<<<<<<< HEAD
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<PublicChatMessagesCubit>().sendMessage(text);
=======
    if (_controller.text.trim().isEmpty) return;
    context.read<PrivateChatMessagesCubit>().sendMessage(_controller.text);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    _controller.clear();
    _scrollToBottom();
  }

<<<<<<< HEAD
  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
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

  bool _canEditMessage(ChatMessage message) {
    final difference = DateTime.now().difference(message.createdAt);
    return difference.inMinutes <= 15;
  }

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
                Navigator.pop(context);
                _chatCubit.setReplyMessage(message);
              },
            ),
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
=======
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final padding = screenWidth * 0.04;
    final avatarRadius = screenWidth * 0.06;
    final fontSizeName = screenWidth * 0.045;
    final fontSizeMessage = screenWidth * 0.04;
    final inputHeight = screenHeight * 0.065;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              SizedBox(height: padding),
              // Header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: screenWidth * 0.06),
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: AppPalette.primary,
                    backgroundImage: widget.partnerImage != null &&
                            widget.partnerImage!.isNotEmpty
                        ? NetworkImage(widget.partnerImage!)
                        : null,
                    child: widget.partnerImage == null ||
                            widget.partnerImage!.isEmpty
                        ? Text(
                            widget.partnerName.isNotEmpty
                                ? widget.partnerName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSizeName,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Text(
                      widget.partnerName,
                      style: TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeName,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Messages
              Expanded(
                child: BlocConsumer<PrivateChatMessagesCubit,
                    PrivateChatMessagesState>(
                  listener: (context, state) {
                    if (state is PrivateChatMessagesLoaded) {
                      // Auto scroll to bottom on new messages
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    if (state is PrivateChatMessagesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PrivateChatMessagesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Failed to load messages',
                              style: TextStyle(fontSize: fontSizeMessage),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<PrivateChatMessagesCubit>()
                                  .loadMessages(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is PrivateChatMessagesLoaded) {
                      if (state.messages.isEmpty) {
                        return Center(
                          child: Text(
                            'No messages yet',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: fontSizeMessage,
                            ),
                          ),
                        );
                      }

                      final currentUserId = context
                          .read<PrivateChatMessagesCubit>()
                          .currentUserId;

                      return Column(
                        children: [
                          if (state.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(padding),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                final isMe = message.senderId == currentUserId;
                                return _chatBubble(
                                  message,
                                  isMe,
                                  fontSizeMessage,
                                  screenWidth,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              // Input
              _messageInput(
                screenWidth: screenWidth,
                fontSizeMessage: fontSizeMessage,
                inputHeight: inputHeight,
              ),
            ],
          ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ),
      ),
    );
  }

<<<<<<< HEAD
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
=======
  Widget _chatBubble(ChatMessageModel message, bool isMe,
      double fontSizeMessage, double screenWidth) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Opacity(
        opacity: message.isPending ? 0.6 : 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
          padding: EdgeInsets.all(screenWidth * 0.035),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF0D035F) : const Color(0xFFF2F5F8),
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: isMe ? Colors.white : const Color(0xFF0D035F),
              fontSize: fontSizeMessage,
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageInput({
    required double screenWidth,
    required double fontSizeMessage,
    required double inputHeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: inputHeight,
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  hintText: "Message...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeMessage,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              size: screenWidth * 0.07,
            ),
            onPressed: _sendMessage,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildMessageList(List messages) {
    final currentUserId = _chatCubit.currentUserId;
    final reversedMessages = messages.reversed.toList(); // ✅ عكس الترتيب

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      reverse: true,
      // ✅ الحل الأساسي
      itemCount: reversedMessages.length,
      itemBuilder: (context, index) {
        final ChatMessage message = reversedMessages[index];
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state is PublicChatMessagesLoaded && state.editingMessage != null)
          EditPreviewBar(
            editingMessage: state.editingMessage!,
            onCancel: () {
              _chatCubit.clearEditing();
              _controller.clear();
            },
          )
        else if (state is PublicChatMessagesLoaded &&
            state.replyMessage != null)
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
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ شيلنا الـ scrollToBottom من هنا
    return BlocProvider.value(
      value: _searchCubit,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchCubit.clearSearch();
                });
              } else {
                Get.back();
              }
            },
          ),
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search messages...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 400), () {
                      _searchCubit.searchMessages(widget.chatId, value);
                    });
                  },
                )
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppPalette.primary,
                      backgroundImage: widget.partnerImage != null &&
                              widget.partnerImage!.isNotEmpty
                          ? NetworkImage(widget.partnerImage!)
                          : null,
                      child: widget.partnerImage == null ||
                              widget.partnerImage!.isEmpty
                          ? Text(widget.partnerName[0])
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.partnerName),
                  ],
                ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => setState(() => _isSearching = true),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'theme') {
                  Get.to(MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => sl<PurchaseCubit>()..getPurchases(),
                      ),
                      BlocProvider.value(
                        value: context.read<MyProfileCubit>(),
                      ),
                    ],
                    child: const ChatThemePage(),
                  ));
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'theme',
                  child: Text('Chat theme'),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            /// 🔹 الشات الأساسي (زي ما هو)
            Column(
              children: [
                Expanded(
                  child: BlocConsumer<PublicChatMessagesCubit,
                      PublicChatMessagesState>(
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
                          return const Center(child: Text('No messages yet'));
                        }
                        return _buildMessageList(state.messages);
                      }

                      if (state is PublicChatMessagesError) {
                        return const Center(child: Text('Error'));
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                /// 🔹 input زي ما هو
                Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: BlocBuilder<PublicChatMessagesCubit,
                      PublicChatMessagesState>(
                    builder: (context, state) {
                      return _messageInput(state);
                    },
                  ),
                ),
              ],
            ),

            /// 🔥 ده بقى الـ Search Overlay
            if (_isSearching)
              Positioned.fill(
                child: Container(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.95),
                  child: BlocBuilder<MessageSearchCubit, MessageSearchState>(
                    builder: (context, searchState) {
                      if (searchState is MessageSearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (searchState is MessageSearchLoaded) {
                        if (searchState.results.isEmpty) {
                          return const Center(child: Text("No messages found"));
                        }

                        return ListView.builder(
                          itemCount: searchState.results.length,
                          itemBuilder: (context, index) {
                            final msg = searchState.results[index];

                            return ListTile(
                              title: Text(msg.content),
                              onTap: () {
                                setState(() => _isSearching = false);
                                _scrollToMessage(msg.id);
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
