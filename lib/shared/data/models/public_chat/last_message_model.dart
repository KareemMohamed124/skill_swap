class LastMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final List<dynamic> readBy;
  final String createdAt;

  LastMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.readBy,
    required this.createdAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? '',
      readBy: json['readBy'] ?? [],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
