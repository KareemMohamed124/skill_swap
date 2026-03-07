import 'package:dio/dio.dart';

/// Plain Dio-based chat API service (no Retrofit code generation needed).
class ChatApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://skill-swaapp.vercel.app';

  ChatApiService(this._dio);

  /// POST /chat/private — Create or get existing private chat
  Future<Map<String, dynamic>> createOrGetPrivateChat(String partnerId) async {
    final response = await _dio.post(
      '$_baseUrl/chat/private',
      data: {'partnerId': partnerId},
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// GET /chat/my-chats — Fetch user's private chats
  Future<List<dynamic>> getMyChats() async {
    final response = await _dio.get('$_baseUrl/chat/my-chats');
    if (response.data is List) {
      return response.data;
    }
    if (response.data is Map<String, dynamic>) {
      // Handle wrapped response like { "chats": [...] }
      final data = response.data as Map<String, dynamic>;
      if (data['chats'] is List) return data['chats'];
      if (data['data'] is List) return data['data'];
    }
    return [];
  }

  /// GET /chat/{chatId}/messages?page=X&limit=Y
  Future<Map<String, dynamic>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      '$_baseUrl/chat/$chatId/messages',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// POST /chat/{chatId}/message — Send a message
  Future<Map<String, dynamic>> sendMessage(
    String chatId,
    String content,
    String type,
  ) async {
    final response = await _dio.post(
      '$_baseUrl/chat/$chatId/message',
      data: {'content': content, 'type': type},
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }
}
