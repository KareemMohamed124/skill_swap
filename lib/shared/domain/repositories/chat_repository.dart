import 'package:skill_swap/shared/data/models/join_track/join_response.dart';
import 'package:skill_swap/shared/data/models/join_track/tracks_response.dart';

import '../../data/models/chat/chat_models.dart';
import '../../data/models/public_chat/get_chat_model.dart';
import '../../data/models/public_chat/get_history_messages.dart';
import '../../data/models/public_chat/send_message_response.dart';

abstract class ChatRepository {
  Future<String> createOrGetPrivateChat(String partnerId);

  Future<List<PrivateChatModel>> getMyChats();

  Future<List<GetChatModel>> getPublicChats();

  Future<List<ChatMessageModel>> getMessages(String chatId,
      {int page = 1, int limit = 20});

  Future<ChatHistoryResponse> getHistoryMessages(String chatId,
      {int page = 1, int limit = 20});

  Future<ChatMessageModel> sendMessage(
      String chatId, String content, String type, {String? replyTo});

  Future<SendMessageResponse> sendMessagePublic(
      String chatId, String content, String type, {String? replyTo});

  Future<TracksResponse> getTracks();

  Future<JoinTrackResponse> joinTrack(String trackId);
}
