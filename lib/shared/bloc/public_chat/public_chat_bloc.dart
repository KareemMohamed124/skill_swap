import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/network/pusher_service.dart';
import '../../data/models/public_chat/chat_response_model.dart';
import '../../domain/repositories/chat_repository.dart';
import 'public_chat_event.dart';
import 'public_chat_state.dart';

class PublicChatBloc extends Bloc<PublicChatEvent, PublicChatState> {
  final ChatRepository repository;
  final PusherService pusherService;
  String? _currentUserId;

  PublicChatBloc(this.repository, this.pusherService)
      : super(PublicChatInitial()) {
    on<GetPublicChatsEvent>(_getGlobalChats);
  }

  Future<void> _getGlobalChats(
    GetPublicChatsEvent event,
    Emitter<PublicChatState> emit,
  ) async {
    emit(PublicChatsLoading());

    try {
      final chats = await repository.getJoinedTrackChats();

      emit(PublicChatsLoaded(
        ChatResponseModel(
          message: "Done",
          chats: chats,
        ),
      ));
    } catch (e) {
      emit(PublicChatsError(e.toString()));
    }
  }
}
