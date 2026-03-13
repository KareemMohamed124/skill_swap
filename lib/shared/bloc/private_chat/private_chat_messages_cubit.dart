import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../shared/core/network/pusher_service.dart';
import '../../data/models/chat/chat_models.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';
import 'private_chat_messages_state.dart';

class PrivateChatMessagesCubit extends Cubit<PrivateChatMessagesState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;

  String? _chatId;
  String? _currentUserId;
  String? _partnerId;

  int _currentPage = 1;
  static const int _pageLimit = 20;

  List<ChatMessageModel> _messages = [];
  bool _hasMore = true;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  PrivateChatMessagesCubit({
    required this.chatRepository,
    required this.pusherService,
  }) : super(PrivateChatMessagesInitial());

  String? get chatId => _chatId;

  String? get currentUserId => _currentUserId;

  Future<void> init(String chatId, {String? partnerId}) async {
    _chatId = chatId;
    _partnerId = partnerId;
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
      isPrivate: true,
      partnerId: _partnerId,
    );

    _messageSubscription =
        pusherService.messageStream.listen(_onPusherNewMessage);

    await loadMessages();
  }

  /// Load messages (first page or reset)
  Future<void> loadMessages() async {
    emit(PrivateChatMessagesLoading());
    try {
      _currentPage = 1;
      final messages = await chatRepository.getMessages(
        _chatId!,
        page: _currentPage,
        limit: _pageLimit,
      );
      _messages = messages.reversed.toList(); // oldest first for display
      _hasMore = messages.length >= _pageLimit;
      emit(PrivateChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    } catch (e) {
      emit(PrivateChatMessagesError(message: e.toString()));
    }
  }

  /// Load older messages (infinite scroll up)
  Future<void> loadMore() async {
    if (!_hasMore) return;
    final currentState = state;
    if (currentState is PrivateChatMessagesLoaded &&
        currentState.isLoadingMore) {
      return;
    }

    if (currentState is PrivateChatMessagesLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    try {
      _currentPage++;
      final olderMessages = await chatRepository.getMessages(
        _chatId!,
        page: _currentPage,
        limit: _pageLimit,
      );

      if (olderMessages.isEmpty) {
        _hasMore = false;
      } else {
        _hasMore = olderMessages.length >= _pageLimit;
        _messages = [...olderMessages.reversed, ..._messages];
      }

      emit(PrivateChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      _currentPage--;
      if (currentState is PrivateChatMessagesLoaded) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  /// Send a message with optimistic UI update
  Future<void> sendMessage(String content) async {
    if (_chatId == null || content.trim().isEmpty) return;
    await pusherService.whenConnected;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = ChatMessageModel(
      id: tempId,
      chatId: _chatId!,
      senderId: _currentUserId ?? '',
      content: content.trim(),
      type: 'text',
      createdAt: DateTime.now(),
      isPending: true,
    );

    _messages.add(optimisticMessage);
    emit(PrivateChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
    ));

    try {
      final serverMessage = await chatRepository.sendMessage(
        _chatId!,
        content.trim(),
        'text',
      );

      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        _messages[index] = serverMessage;
      } else {
        _messages.add(serverMessage);
      }

      emit(PrivateChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    } catch (e) {
      _messages.removeWhere((m) => m.id == tempId);
      emit(PrivateChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    }
  }

  /// Handle incoming Pusher message
  void _onPusherNewMessage(Map<String, dynamic> data) {
    if (isClosed) return;

    try {
      final messageData = data['message'] is Map<String, dynamic>
          ? data['message'] as Map<String, dynamic>
          : data;

      final messageChatId = messageData['chat']?.toString() ??
          messageData['chatId']?.toString() ??
          '';

      if (messageChatId != _chatId && messageChatId.isNotEmpty) return;

      final newMessage = ChatMessageModel.fromJson(messageData);

      // Don't add if it's our own message (already added via optimistic update)
      if (newMessage.senderId == _currentUserId) {
        final exists = _messages.any((m) =>
            m.id == newMessage.id ||
            (m.content == newMessage.content &&
                m.senderId == newMessage.senderId &&
                m.isPending));
        if (exists) return;
      }

      // Don't add duplicates by ID
      if (_messages.any((m) => m.id == newMessage.id)) return;

      _messages.add(newMessage);
      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      emit(PrivateChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
      ));
    } catch (e) {
      print('❌ error handling pusher message $e');
    }
  }
}
