import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../shared/core/network/pusher_service.dart';
import '../../data/models/public_chat/common_sender.dart';
import '../../data/models/public_chat/get_history_messages.dart';
import '../../data/models/public_chat/reply_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';
import 'public_chat_messages_state.dart';

class PublicChatMessagesCubit extends Cubit<PublicChatMessagesState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;

  String? _chatId;
  String? _currentUserId;

  bool _isPrivate = false;
  String? _partnerId;

  int _currentPage = 1;
  static const int _pageLimit = 20;

  List<ChatMessage> _messages = [];
  bool _hasMore = true;

  ChatMessage? _replyMessage;
  ChatMessage? _editingMessage;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  PublicChatMessagesCubit({
    required this.chatRepository,
    required this.pusherService,
  }) : super(PublicChatMessagesInitial());

  String? get chatId => _chatId;

  String? get currentUserId => _currentUserId;

  ChatMessage? get replyMessage => _replyMessage;

  ChatMessage? get editingMessage => _editingMessage;

  // ============= REPLY =============
  void setReplyMessage(ChatMessage message) {
    _replyMessage = message;
    _editingMessage = null;
    if (state is PublicChatMessagesLoaded) {
      emit((state as PublicChatMessagesLoaded)
          .copyWith(replyMessage: message, clearEditing: true));
    }
  }

  void clearReply() {
    _replyMessage = null;
    if (state is PublicChatMessagesLoaded) {
      emit((state as PublicChatMessagesLoaded).copyWith(clearReply: true));
    }
  }

  // ============= EDITING =============
  void setEditingMessage(ChatMessage message) {
    _editingMessage = message;
    _replyMessage = null;
    if (state is PublicChatMessagesLoaded) {
      emit((state as PublicChatMessagesLoaded)
          .copyWith(editingMessage: message, clearReply: true));
    }
  }

  void clearEditing() {
    _editingMessage = null;
    if (state is PublicChatMessagesLoaded) {
      emit((state as PublicChatMessagesLoaded).copyWith(clearEditing: true));
    }
  }

  // ============= INIT =============
  Future<void> init(
    String chatId, {
    bool isPrivate = false,
    String? partnerId,
  }) async {
    _chatId = chatId;
    _isPrivate = isPrivate;
    _partnerId = partnerId;

    _currentUserId = await LocalStorage.getUserId();
    _currentPage = 1;
    _messages = [];
    _hasMore = true;
    _replyMessage = null;
    _editingMessage = null;

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

  // ============= LOAD MESSAGES =============
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

  // ============= SEND MESSAGE =============
  Future<void> sendMessage(String content) async {
    if (_chatId == null || content.trim().isEmpty) return;

    if (_editingMessage != null) {
      await editMessage(_editingMessage!.id, content.trim());
      return;
    }

    await pusherService.whenConnected;

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

    emit(PublicChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
      replyMessage: _replyMessage,
      editingMessage: _editingMessage,
    ));

    final replyToId = _replyMessage?.id;
    clearReply();

    try {
      final serverMessageResponse = await chatRepository.sendMessage(
        _chatId!,
        content.trim(),
        'text',
        replyTo: replyToId,
      );

      final serverMessage = ChatMessage(
        id: serverMessageResponse.data.id,
        chatId: serverMessageResponse.data.chatId,
        senderId: serverMessageResponse.data.senderId,
        content: serverMessageResponse.data.content,
        messageType: serverMessageResponse.data.messageType,
        readBy: serverMessageResponse.data.readBy,
        createdAt: serverMessageResponse.data.createdAt,
        updatedAt: serverMessageResponse.data.updatedAt,
        replyTo: serverMessageResponse.data.replyTo,
        v: serverMessageResponse.data.v,
      );

      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1)
        _messages[index] = serverMessage;
      else
        _messages.add(serverMessage);

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      _messages.removeWhere((m) => m.id == tempId);
      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    }
  }

  // ================= EDIT MESSAGE (LIMIT 15 MINUTES) =================
  Future<void> editMessage(String messageId, String content) async {
    if (_chatId == null) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final originalMessage = _messages[index];

    // ✅ السماح بالتعديل فقط خلال 15 دقيقة من إنشاء الرسالة
    final difference = DateTime.now().difference(originalMessage.createdAt);
    if (difference.inMinutes > 15) {
      print("❌ Time to edit this message has expired");
      return;
    }

    _messages[index] =
        originalMessage.copyWith(content: content, isEdited: true);

    _editingMessage = null;

    emit(PublicChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
      replyMessage: _replyMessage,
    ));

    try {
      await chatRepository.editMessage(_chatId!, messageId, content);
    } catch (e) {
      _messages[index] = originalMessage;
      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
      ));
    }
  }

  // ============= DELETE MESSAGE =============
  Future<void> deleteMessage(String messageId) async {
    if (_chatId == null) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final originalMessage = _messages[index];
    _messages.removeAt(index);

    emit(PublicChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
      replyMessage: _replyMessage,
      editingMessage: _editingMessage,
    ));

    try {
      await chatRepository.deleteMessage(_chatId!, messageId);
    } catch (e) {
      _messages.insert(index, originalMessage);
      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    }
  }

  // ============= PUSHER EVENTS =============
  void _onPusherEvent(Map<String, dynamic> data) {
    if (isClosed) return;

    final eventType = data['_eventType']?.toString() ?? 'receive_message';

    switch (eventType) {
      case 'message_edited':
        _handleMessageUpdated(data);
        break;
      case 'message_deleted':
        _handleMessageDeleted(data);
        break;
      case 'messages_read':
        _handleMessagesRead(data);
        break;
      default:
        _handleNewMessage(data);
        break;
    }
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      final messageData = data['message'] is Map<String, dynamic>
          ? data['message'] as Map<String, dynamic>
          : data;

      final messageChatId = messageData['chatId']?.toString() ?? '';
      if (messageChatId != _chatId) return;

      final senderData = messageData['senderData'] ?? {};
      final senderId = messageData['senderId']?.toString() ?? 'unknown';
      final senderName = senderData['userName']?.toString() ?? 'unknown';

      String userImageUrl =
          senderData['userImage']?['secure_url']?.toString() ?? '';

      if (userImageUrl.isEmpty) {
        try {
          final oldMessage =
              _messages.firstWhere((m) => m.senderId.id == senderId);
          userImageUrl = oldMessage.senderId.userImage.secureUrl;
        } catch (_) {}
      }

      final newMessage = ChatMessage(
        id: messageData['id']?.toString() ?? DateTime.now().toString(),
        chatId: messageChatId,
        senderId: Sender(
          id: senderId,
          userImage: UserImage(secureUrl: userImageUrl, publicId: ''),
          name: senderName,
          role: '',
        ),
        content: messageData['message']?.toString() ?? '',
        messageType: messageData['messageType']?.toString() ?? 'text',
        readBy: [],
        createdAt:
            DateTime.tryParse(messageData['timestamp'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.now(),
        replyTo: messageData['replyTo'] != null
            ? ReplyMessage.fromJson(messageData['replyTo'])
            : null,
        v: 0,
      );

      if (senderId == _currentUserId) {
        final tempIndex = _messages.indexWhere((m) =>
            m.id.startsWith('temp_') &&
            m.content == newMessage.content &&
            m.senderId.id == senderId);

        if (tempIndex != -1) {
          _messages[tempIndex] = newMessage;

          emit(PublicChatMessagesLoaded(
            messages: List.from(_messages),
            hasMore: _hasMore,
            replyMessage: _replyMessage,
            editingMessage: _editingMessage,
          ));
        }
        return;
      }

      final exists = _messages.any((m) =>
          m.id == newMessage.id ||
          (m.content == newMessage.content &&
              m.senderId.id == newMessage.senderId.id &&
              m.createdAt.difference(newMessage.createdAt).inSeconds.abs() < 2));

      if (exists) return;

      final tempIndex = _messages.indexWhere((m) =>
          m.id.startsWith('temp_') &&
          m.content == newMessage.content &&
          m.senderId.id == newMessage.senderId.id);

      if (tempIndex != -1) {
        _messages[tempIndex] = newMessage;
      } else {
        _messages.add(newMessage);
      }

      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      print('❌ error handling pusher message $e');
    }
  }

  void _handleMessageUpdated(Map<String, dynamic> data) {
    try {
      final messageId =
          data['messageId']?.toString() ?? data['_id']?.toString() ?? '';
      final newContent =
          data['newContent']?.toString() ?? data['content']?.toString() ?? '';
      if (messageId.isEmpty || newContent.isEmpty) return;

      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index == -1) return;

      _messages[index] =
          _messages[index].copyWith(content: newContent, isEdited: true);

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      print('❌ error handling message_edited $e');
    }
  }

  void _handleMessageDeleted(Map<String, dynamic> data) {
    try {
      final messageId =
          data['messageId']?.toString() ?? data['_id']?.toString() ?? '';
      if (messageId.isEmpty) return;

      _messages.removeWhere((m) => m.id == messageId);

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      print('❌ error handling message_deleted $e');
    }
  }

  Future<void> markMessagesAsRead() async {
    if (_chatId == null) return;
    try {
      await chatRepository.markMessagesAsRead(_chatId!);
    } catch (e) {
      print('❌ error marking messages as read $e');
    }
  }

  void _handleMessagesRead(Map<String, dynamic> data) {
    try {
      bool changed = false;
      for (int i = 0; i < _messages.length; i++) {
        if (!_messages[i].isSeen) {
          _messages[i] = _messages[i].copyWith(isSeen: true);
          changed = true;
        }
      }

      if (changed) {
        emit(PublicChatMessagesLoaded(
          messages: List.from(_messages),
          hasMore: _hasMore,
          replyMessage: _replyMessage,
          editingMessage: _editingMessage,
        ));
      }
    } catch (e) {
      print('❌ error handling messages_read $e');
    }
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