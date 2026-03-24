import 'package:skill_swap/shared/data/models/public_chat/reply_message.dart';

import 'common_sender.dart';

class ChatHistoryResponse {
  final String message;
  final String userId;
  final List<ChatMessage> messages;
  final int total;
  final int page;
  final int totalPages;

  ChatHistoryResponse({
    required this.message,
    required this.userId,
    required this.messages,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) =>
      ChatHistoryResponse(
        message: json['message'],
        userId: json['userId'],
        messages: List<ChatMessage>.from(
            json['messages'].map((x) => ChatMessage.fromJson(x))),
        total: json['total'],
        page: json['page'],
        totalPages: json['totalPages'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'userId': userId,
        'messages': List<dynamic>.from(messages.map((x) => x.toJson())),
        'total': total,
        'page': page,
        'totalPages': totalPages,
      };
}

class ChatMessage {
  final String id;
  final String chatId;
  final Sender senderId;
  final String content;
  final String messageType;
  final List<dynamic> readBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReplyMessage? replyTo;
  final int v;
  final bool isEdited;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.readBy,
    required this.createdAt,
    required this.updatedAt,
    this.replyTo,
    required this.v,
    this.isEdited = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['_id'],
        chatId: json['chatId'],
        senderId: Sender.fromJson(json['senderId']),
        content: json['content'],
        messageType: json['messageType'],
        readBy: json['readBy'] ?? [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        replyTo: json['replyTo'] != null
            ? ReplyMessage.fromJson(json['replyTo'])
            : null,
        v: json['__v'],
        isEdited: json['isEdited'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chatId': chatId,
        'senderId': senderId.toJson(),
        'content': content,
        'messageType': messageType,
        'readBy': readBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (replyTo != null) 'replyTo': replyTo!.toJson(),
        '__v': v,
        'isEdited': isEdited,
      };

  ChatMessage copyWith({
    String? id,
    String? chatId,
    Sender? senderId,
    String? content,
    String? messageType,
    List<dynamic>? readBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReplyMessage? replyTo,
    int? v,
    bool? isEdited,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      readBy: readBy ?? this.readBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replyTo: replyTo ?? this.replyTo,
      v: v ?? this.v,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
