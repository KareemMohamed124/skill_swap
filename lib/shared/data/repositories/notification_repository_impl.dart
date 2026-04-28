import 'dart:developer';

import '../../domain/repositories/notification_repository.dart';
import '../web_services/notification/notification_api.dart';
import '../web_services/notification/notification_request.dart';
import '../web_services/notification/test_notification_request.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi api;

  NotificationRepositoryImpl(this.api);

  @override
  Future<void> saveFcmToken(String token) async {
    await api.saveFcmToken(
      NotificationRequest(fcmToken: token),
    );
  }

  @override
  Future<void> deleteFcmToken() async {
    await api.deleteFcmToken();
  }

  @override
  Future<void> sendNotification({
    required String receiverId,
    required String type,
    Map<String, dynamic> payload = const {},
  }) async {
    try {
      await api.sendNotification(
        SendNotificationRequest(
          receiverId: receiverId,
          type: type,
          payload: payload,
        ),
      );
      log("Notification sent: type=$type, to=$receiverId");
    } catch (e) {
      // Don't crash the main flow if notification fails
      log("Error sending notification: $e");
    }
  }
}
