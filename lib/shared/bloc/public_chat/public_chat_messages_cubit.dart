import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../shared/core/network/pusher_service.dart';
import '../../constants/not_type.dart';
import '../../data/models/public_chat/common_sender.dart';
import '../../data/models/public_chat/get_history_messages.dart';
import '../../data/models/public_chat/reply_message.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../helper/local_storage.dart';
import 'public_chat_messages_state.dart';

class PublicChatMessagesCubit extends Cubit<PublicChatMessagesState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;

  String? _chatId;
  String? _currentUserId;

  bool _isPrivate = false;
  String? _partnerId;
  int? _participantsCount;

  int _currentPage = 1;
  static const int _pageLimit = 20;

  List<ChatMessage> _messages = [];
  bool _hasMore = true;

  ChatMessage? _replyMessage;
  ChatMessage? _editingMessage;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  final Map<String, String> _senderThemeCache = {};

  PublicChatMessagesCubit({
    required this.chatRepository,
    required this.pusherService,
  }) : super(PublicChatMessagesInitial());

  String? get chatId => _chatId;
  String? get currentUserId => _currentUserId;
  ChatMessage? get replyMessage => _replyMessage;
  ChatMessage? get editingMessage => _editingMessage;
  Map<String, String> get senderThemeCache => _senderThemeCache;

  // ================= HELPER =================
  PublicChatMessagesLoaded _emitLoaded() {
    return PublicChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
      replyMessage: _replyMessage,
      editingMessage: _editingMessage,
    );
  }

  // ================= INIT =================
  Future<void> init(
    String chatId, {
    bool isPrivate = false,
    String? partnerId,
    int? participantsCount,
  }) async {
    _chatId = chatId;
    _isPrivate = isPrivate;

    _currentUserId = await LocalStorage.getUserId();

    // ✅ FIX: prevent sending notification to yourself
    if (partnerId != null && partnerId != _currentUserId) {
      _partnerId = partnerId;
    } else {
      _partnerId = null;
    }

    _participantsCount = participantsCount;

    _currentPage = 1;
    _messages = [];
    _hasMore = true;
    _replyMessage = null;
    _editingMessage = null;
    _senderThemeCache.clear();

    await _messageSubscription?.cancel();

    if (_currentUserId != null) {
      await pusherService.init(userId: _currentUserId!);
      await pusherService.whenConnected;
    }

    await pusherService.subscribeToChat(chatId: chatId);
    _messageSubscription = pusherService.messageStream.listen(_onPusherEvent);

    await loadMessages();
    await markMessagesAsRead();
  }

  // ================= LOAD =================
  Future<void> loadMessages() async {
    emit(PublicChatMessagesLoading());

    try {
      _currentPage = 1;

      final response = await chatRepository.getMessages(
        _chatId!,
        page: _currentPage,
        limit: _pageLimit,
      );

      _messages = response.messages.toList();
      _hasMore = response.messages.length >= _pageLimit;

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      emit(PublicChatMessagesError(message: e.toString()));
    }
  }

  // ================= SEND =================
  Future<void> sendMessage(String content) async {
    if (_chatId == null || content.trim().isEmpty) return;

    if (_editingMessage != null) {
      await editMessage(_editingMessage!.id, content.trim());
      return;
    }

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final optimisticMessage = ChatMessage(
      id: tempId,
      chatId: _chatId!,
      senderId: Sender(
        id: _currentUserId ?? '',
        userImage: UserImage(secureUrl: '', publicId: ''),
        name: '',
        role: '',
      ),
      content: content.trim(),
      messageType: 'text',
      readBy: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: MessageStatus.sending,
      theme: null,
      replyTo: _replyMessage != null
          ? ReplyMessage(
              id: _replyMessage!.id,
              content: _replyMessage!.content,
              type: _replyMessage!.messageType,
              senderName: _replyMessage!.senderId.name ?? 'Unknown',
              createdAt: _replyMessage!.createdAt,
            )
          : null,
      v: 0,
    );

    _messages.add(optimisticMessage);
    emit(_emitLoaded());

    final replyToId = _replyMessage?.id;
    _replyMessage = null;

    _trySendMessage(tempId, optimisticMessage, replyToId);
  }

  // ================= TRY SEND =================
  Future<void> _trySendMessage(
      String tempId, ChatMessage message, String? replyToId) async {
    final index = _messages.indexWhere((m) => m.id == tempId);
    if (index == -1) return;

    bool notificationSent = false;

    try {
      final res = await chatRepository.sendMessage(
        _chatId!,
        message.content,
        'text',
        replyTo: replyToId,
      );

      _messages[index] = message.copyWith(
        id: res.data.id,
        status: MessageStatus.sent,
      );

      emit(_emitLoaded());

      // ================= SAFE NOTIFICATION =================
      final shouldSendNotification = _isPrivate &&
          _partnerId != null &&
          _partnerId!.isNotEmpty &&
          _partnerId != _currentUserId;

      if (!notificationSent && shouldSendNotification) {
        notificationSent = true;

        final senderName = _messages
                .firstWhere(
                  (m) => m.senderId.id == _currentUserId,
                  orElse: () => _messages.first,
                )
                .senderId
                .name ??
            'Someone';

        await sl<NotificationRepository>().sendNotification(
          receiverId: _partnerId!,
          type: NotificationTypes.chatMessage,
          payload: {
            'chatId': _chatId!,
            'senderName': senderName,
            'senderId': _currentUserId ?? '',
            'messagePreview': message.content.length > 100
                ? message.content.substring(0, 100)
                : message.content,
          },
        );
      }
    } catch (e) {
      _messages[index] = message.copyWith(status: MessageStatus.failed);
      emit(_emitLoaded());

      Future.delayed(const Duration(seconds: 3), () {
        final i = _messages.indexWhere((m) => m.id == tempId);
        if (i != -1 && _messages[i].status == MessageStatus.failed) {
          _retryMessage(tempId, replyToId);
        }
      });
    }
  }

  // ================= RETRY =================
  Future<void> _retryMessage(String tempId, String? replyToId) async {
    final index = _messages.indexWhere((m) => m.id == tempId);
    if (index == -1) return;

    final message = _messages[index];

    _messages[index] = message.copyWith(status: MessageStatus.sending);
    emit(_emitLoaded());

    _trySendMessage(tempId, message, replyToId);
  }

  // ================= REPLY / EDITING STATE =================
  void setReplyMessage(ChatMessage message) {
    _replyMessage = message;
    emit(_emitLoaded());
  }

  void clearReply() {
    _replyMessage = null;
    emit(_emitLoaded());
  }

  void setEditingMessage(ChatMessage message) {
    _editingMessage = message;
    emit(_emitLoaded());
  }

  void clearEditing() {
    _editingMessage = null;
    emit(_emitLoaded());
  }

  // ================= EDIT =================
  Future<void> editMessage(String messageId, String content) async {
    if (_chatId == null) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final old = _messages[index];
    _messages[index] = old.copyWith(content: content, isEdited: true);

    _editingMessage = null;

    emit(_emitLoaded());

    try {
      await chatRepository.editMessage(_chatId!, messageId, content);
    } catch (e) {
      _messages[index] = old;
      emit(_emitLoaded());
    }
  }

  // ================= DELETE =================
  Future<void> deleteMessage(String messageId) async {
    if (_chatId == null) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final old = _messages[index];
    _messages.removeAt(index);

    emit(_emitLoaded());

    try {
      await chatRepository.deleteMessage(_chatId!, messageId);
    } catch (e) {
      _messages.insert(index, old);
      emit(_emitLoaded());
    }
  }

  // ================= PUSHER =================
  void _onPusherEvent(Map<String, dynamic> data) {
    if (isClosed) return;

    final eventType = data['_eventType'] ?? 'receive_message';

    switch (eventType) {
      case 'message_edited':
        _handleMessageUpdated(data);
        break;
      case 'message_deleted':
        _handleMessageDeleted(data);
        break;
      default:
        break;
    }
  }

  void _handleMessageUpdated(Map<String, dynamic> data) {}
  void _handleMessageDeleted(Map<String, dynamic> data) {}

  Future<void> markMessagesAsRead() async {
    if (_chatId == null) return;
    await chatRepository.markMessagesAsRead(_chatId!);
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    if (_chatId != null && _currentUserId != null) {
      pusherService.unsubscribeFromChat(_chatId!);
    }
    return super.close();
  }
}
