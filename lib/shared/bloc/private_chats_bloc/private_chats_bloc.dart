import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/private_chats_bloc/private_chats_event.dart';
import 'package:skill_swap/shared/bloc/private_chats_bloc/private_chats_state.dart';

import '../../data/models/public_chat/get_chat_model.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';

class PrivateChatsBloc extends Bloc<PrivateChatEvent, PrivateChatsState> {
  final ChatRepository repository;

  List<GetChatModel> cache = [];

  final Map<String, int> unreadMap = {};

  PrivateChatsBloc(this.repository) : super(PrivateChatsInitial()) {
    on<GetPrivateChatsEvent>(_getPrivateChats);
  }

  Future<void> _getPrivateChats(
    GetPrivateChatsEvent event,
    Emitter<PrivateChatsState> emit,
  ) async {
    try {
      emit(PrivateChatsLoading());

      final currentUserId = await LocalStorage.getUserId() ?? '';
      final chats = await repository.getPrivateChats();

      cache = chats;

      unreadMap.clear();

      for (final chat in chats) {
        final history = await repository.getMessages(
          chat.id,
          page: 1,
          limit: 100,
        );

        final unreadCount = history.messages.where((msg) {
          final senderId = msg.senderId.id;

          if (senderId == currentUserId) return false;

          return !msg.readBy.contains(currentUserId);
        }).length;

        unreadMap[chat.id] = unreadCount;
      }

      emit(PrivateChatsLoaded(chats));
    } catch (e) {
      emit(PrivateChatsError(e.toString()));
    }
  }
}
