abstract class NotificationRepository {
  Future<void> saveFcmToken(String token);

  Future<void> deleteFcmToken();

//Future<void> sendTestNotification();
}
