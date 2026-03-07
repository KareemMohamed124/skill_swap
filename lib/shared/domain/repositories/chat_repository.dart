import '../../data/models/chat/chat_models.dart';

abstract class ChatRepository {
  Future<String> createOrGetPrivateChat(String partnerId);
  Future<List<PrivateChatModel>> getMyChats();
  Future<List<ChatMessageModel>> getMessages(String chatId,
      {int page = 1, int limit = 20});
  Future<ChatMessageModel> sendMessage(
      String chatId, String content, String type);
}
