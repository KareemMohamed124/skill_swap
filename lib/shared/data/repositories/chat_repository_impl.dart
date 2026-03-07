import 'package:dio/dio.dart';

import '../../helper/local_storage.dart';
import '../models/chat/chat_models.dart';
import '../web_services/chat/chat_api_service.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiService api;

  ChatRepositoryImpl({required this.api});

  @override
  Future<String> createOrGetPrivateChat(String partnerId) async {
    try {
      final response = await api.createOrGetPrivateChat(partnerId);
      // The response may have the chat ID at various keys
      return response['_id']?.toString() ??
          response['id']?.toString() ??
          response['chatId']?.toString() ??
          (response['chat'] is Map
              ? (response['chat']['_id']?.toString() ??
                  response['chat']['id']?.toString() ??
                  '')
              : '');
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<List<PrivateChatModel>> getMyChats() async {
    try {
      final currentUserId = await LocalStorage.getUserId() ?? '';
      final response = await api.getMyChats();
      return response
          .where((item) => item is Map<String, dynamic>)
          .map((item) => PrivateChatModel.fromJson(
              item as Map<String, dynamic>, currentUserId))
          .toList();
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String chatId,
      {int page = 1, int limit = 20}) async {
    try {
      final response = await api.getMessages(chatId, page: page, limit: limit);
      final messages =
          response['messages'] ?? response['data'] ?? response['docs'] ?? [];
      if (messages is List) {
        return messages
            .where((item) => item is Map<String, dynamic>)
            .map((item) =>
                ChatMessageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(
      String chatId, String content, String type) async {
    try {
      final response = await api.sendMessage(chatId, content, type);
      // The response may wrap the message in a key
      final messageData = response['message'] is Map<String, dynamic>
          ? response['message'] as Map<String, dynamic>
          : response;
      return ChatMessageModel.fromJson(messageData);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  String _extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is String) return data;
    } catch (_) {}
    return e.message ?? 'Network Error';
  }
}
