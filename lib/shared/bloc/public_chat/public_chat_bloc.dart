import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/network/pusher_service.dart';
import '../../domain/repositories/chat_repository.dart';
import 'public_chat_event.dart';
import 'public_chat_state.dart';

class PublicChatBloc extends Bloc<PublicChatEvent, PublicChatState> {
  final ChatRepository repository;
  final PusherService pusherService;

  PublicChatBloc(this.repository, this.pusherService)
      : super(PublicChatInitial()) {
    on<GetPublicChatsEvent>(_getGlobalChats);
  }

  Future<void> _getGlobalChats(GetPublicChatsEvent event,
      Emitter<PublicChatState> emit,) async {
    emit(PublicChatsLoading());

    try {
      final result = await repository.getMyChatsPublic();

      for (final chat in result.chats) {
        final chatId = chat.id;
        await pusherService.subscribeToPublicChatChannel(chatId);
      }

      emit(PublicChatsLoaded(result));
    } catch (e) {
      emit(PublicChatsError(e.toString()));
    }
  }
}
