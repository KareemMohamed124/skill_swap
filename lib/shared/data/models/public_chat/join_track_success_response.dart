import 'chat_model.dart';

class JoinTrackSuccessResponse {
  final String message;
  final Chat chatDetails;

  JoinTrackSuccessResponse({
    required this.message,
    required this.chatDetails,
  });

  factory JoinTrackSuccessResponse.fromJson(Map<String, dynamic> json) {
    return JoinTrackSuccessResponse(
      message: json['message'] ?? '',
      chatDetails: Chat.fromJson(json['chat'] as Map<String, dynamic>),
    );
  }
}
