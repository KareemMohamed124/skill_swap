import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../shared/core/network/pusher_service.dart';
import '../../data/models/public_chat/common_sender.dart';
import '../../data/models/public_chat/get_history_messages.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';
import 'public_chat_messages_state.dart';

class PublicChatMessagesCubit extends Cubit<PublicChatMessagesState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;

  String? _chatId;
  String? _currentUserId;

  int _currentPage = 1;
  static const int _pageLimit = 20;

  List<ChatMessage> _messages = [];
  bool _hasMore = true;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  PublicChatMessagesCubit({
    required this.chatRepository,
    required this.pusherService,
  }) : super(PublicChatMessagesInitial());

  String? get chatId => _chatId;

  String? get currentUserId => _currentUserId;

  Future<void> init(String chatId) async {
    _chatId = chatId;
    _currentUserId = await LocalStorage.getUserId();

    _currentPage = 1;
    _messages = [];
    _hasMore = true;

    await _messageSubscription?.cancel();

    if (_currentUserId != null) {
      await pusherService.init(userId: _currentUserId!);
      await pusherService.whenConnected;
    }

    await pusherService.subscribeToChat(
      chatId: chatId,
      currentUserId: _currentUserId!,
      isPrivate: false,
    );

    _messageSubscription =
        pusherService.messageStream.listen(_onPusherNewMessage);

    await loadMessages();
  }

  Future<void> loadMessages() async {
    emit(PublicChatMessagesLoading());

    try {
      _currentPage = 1;

      final response = await chatRepository.getHistoryMessages(
        _chatId!,
        page: _currentPage,
        limit: _pageLimit,
      );

      _messages = response.messages.reversed.toList();
      _hasMore = response.messages.length >= _pageLimit;

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    } catch (e) {
      emit(PublicChatMessagesError(message: e.toString()));
    }
  }

  Future<void> sendMessage(String content) async {
    if (_chatId == null || content.trim().isEmpty) return;
    await pusherService.whenConnected;
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final optimisticMessage = ChatMessage(
      id: tempId,
      chatId: _chatId!,
      senderId: Sender(
        id: _currentUserId ?? '',
        userImage: UserImage(secureUrl: '', publicId: ''),
      ),
      content: content.trim(),
      messageType: 'text',
      readBy: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      v: 0,
    );

    _messages.add(optimisticMessage);

    emit(PublicChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
    ));

    try {
      final serverMessageResponse = await chatRepository.sendMessagePublic(
        _chatId!,
        content.trim(),
        'text',
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
        v: serverMessageResponse.data.v,
      );

      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        _messages[index] = serverMessage;
      } else {
        _messages.add(serverMessage);
      }

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    } catch (e) {
      _messages.removeWhere((m) => m.id == tempId);
      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    }
  }

  void _onPusherNewMessage(Map<String, dynamic> data) {
    if (isClosed) return;

    try {
      final messageData = data['message'] is Map<String, dynamic>
          ? data['message'] as Map<String, dynamic>
          : data;

      final messageChatId = messageData['chatId']?.toString() ?? '';
      if (messageChatId != _chatId) return;

      final senderData = messageData['senderData'] ?? {};
      final senderId = messageData['senderId']?.toString() ?? 'unknown';

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
        ),
        content: messageData['message']?.toString() ?? '',
        messageType: messageData['messageType']?.toString() ?? 'text',
        readBy: [],
        createdAt:
            DateTime.tryParse(messageData['timestamp'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );

      if (senderId == _currentUserId) return;

      if (_messages.any((m) => m.id == newMessage.id)) return;

      // _messages.add(newMessage);
      _messages.add(newMessage);
      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    } catch (e) {
      print('❌ error handling pusher message $e');
    }
  }
// @override
// Future<void> close() {
//   _messageSubscription?.cancel();
//
//   if (_chatId != null) {
//     pusherService.unsubscribeFromChatChannel(_chatId!);
//   }
//
//   return super.close();
// }
}
