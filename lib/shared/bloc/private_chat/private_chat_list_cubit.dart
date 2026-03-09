import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../shared/core/network/pusher_service.dart';
import '../../data/models/chat/chat_models.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';
import 'private_chat_list_state.dart';

class PrivateChatListCubit extends Cubit<PrivateChatListState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;

  List<PrivateChatModel> _chats = [];
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  PrivateChatListCubit({
    required this.chatRepository,
    required this.pusherService,
  }) : super(PrivateChatListInitial()) {
    // Listen to Pusher message stream for chat list updates
    _messageSubscription =
        pusherService.messageStream.listen(_onPusherChatListUpdate);
  }

  Future<void> fetchChats() async {
    emit(PrivateChatListLoading());
    try {
      final userId = await LocalStorage.getUserId();
      if (userId != null) {
        await pusherService.init(userId: userId);
      }

      _chats = await chatRepository.getMyChats();
      _chats.sort((a, b) {
        final aTime = a.lastMessageTime ?? DateTime(2000);
        final bTime = b.lastMessageTime ?? DateTime(2000);
        return bTime.compareTo(aTime); // newest first
      });
      final totalUnread =
          _chats.fold<int>(0, (sum, chat) => sum + chat.unreadCount);
      emit(PrivateChatListLoaded(chats: _chats, totalUnread: totalUnread));
    } catch (e) {
      emit(PrivateChatListError(message: e.toString()));
    }
  }

  /// Create or get private chat, returns chatId
  Future<String> createOrGetChat(String partnerId) async {
    return await chatRepository.createOrGetPrivateChat(partnerId);
  }

  /// Called when a Pusher event updates the chat list (e.g., new message arrives)
  void _onPusherChatListUpdate(Map<String, dynamic> data) {
    if (isClosed) return;
    // Refresh the chat list from API to get updated last messages & unread counts
    fetchChats();
  }

  /// Update a specific chat's last message (for optimistic local update)
  void updateChatLastMessage(String chatId, String lastMessage, DateTime time) {
    final index = _chats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      _chats[index] = _chats[index].copyWith(
        lastMessage: lastMessage,
        lastMessageTime: time,
      );
      _chats.sort((a, b) {
        final aTime = a.lastMessageTime ?? DateTime(2000);
        final bTime = b.lastMessageTime ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
      final totalUnread =
          _chats.fold<int>(0, (sum, chat) => sum + chat.unreadCount);
      emit(PrivateChatListLoaded(
          chats: List.from(_chats), totalUnread: totalUnread));
    }
  }

  /// Mark a chat as read (reset unread count)
  void markChatAsRead(String chatId) {
    final index = _chats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      _chats[index] = _chats[index].copyWith(unreadCount: 0);
      final totalUnread =
          _chats.fold<int>(0, (sum, chat) => sum + chat.unreadCount);
      emit(PrivateChatListLoaded(
          chats: List.from(_chats), totalUnread: totalUnread));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
