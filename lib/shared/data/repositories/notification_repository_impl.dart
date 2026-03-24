import '../../domain/repositories/notification_repository.dart';
import '../web_services/notification/notification_api.dart';
import '../web_services/notification/notification_request.dart';

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

// @override
// Future<void> sendTestNotification() async {
//   await api.sendTestNotification();
// }
}
