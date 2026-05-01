import 'package:bloc/bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'message_search_state.dart';

class MessageSearchCubit extends Cubit<MessageSearchState> {
  final ChatRepository chatRepository;

  MessageSearchCubit({required this.chatRepository}) : super(MessageSearchInitial());

  Future<void> searchMessages(String chatId, String query) async {
    if (query.trim().isEmpty) {
      emit(MessageSearchInitial());
      return;
    }

    emit(MessageSearchLoading());

    try {
      final results = await chatRepository.searchMessages(chatId, query);
      emit(MessageSearchLoaded(results: results, query: query));
    } catch (e) {
      emit(MessageSearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(MessageSearchInitial());
  }
}
