import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../common_ui/screen_manager/screen_manager.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ─────────────────────────────────────────────
  // Android notification channel (must match everywhere)
  // ─────────────────────────────────────────────
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'skillswap_notifications', // id
    'SkillSwap Notifications', // name
    description: 'Notifications for SkillSwap app',
    importance: Importance.max,
  );

  /// INIT
  static Future<void> init() async {
    await _requestPermission();

    // Tell FCM to NOT show its own heads-up in foreground
    // (we show them ourselves via flutter_local_notifications)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    await _initLocalNotifications();

    await _registerToken();

    _listenForeground();

    _listenClick();

    _listenTokenRefresh();

    // Handle the case where the app was terminated and opened via
    // a notification tap.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleNotification(initialMessage);
    }
  }

  /// REQUEST PERMISSION
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("Notification Permission: ${settings.authorizationStatus}");
  }

  /// GET TOKEN + SEND TO BACKEND
  static Future<void> _registerToken() async {
    String? token = await _messaging.getToken();

    log("FCM TOKEN: $token");

    if (token == null) return;

    try {
      await sl<NotificationRepository>().saveFcmToken(token);
      log("FCM token sent to backend");
    } catch (e) {
      log("Error sending FCM token: $e");
    }
  }

  /// TOKEN REFRESH
  static void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log("New FCM TOKEN: $newToken");

      try {
        await sl<NotificationRepository>().saveFcmToken(newToken);
      } catch (e) {
        log("Error updating token");
      }
    });
  }

  /// INIT LOCAL NOTIFICATION
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create the notification channel on Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Called when the user taps a LOCAL notification (foreground banner)
  static void _onNotificationTap(NotificationResponse response) {
    log("Local notification tapped – payload: ${response.payload}");

    final String type = response.payload ?? "";
    _navigateByType(type);
  }

  /// FOREGROUND
  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FOREGROUND MESSAGE ARRIVED");
      log("NOTIFICATION: ${message.notification}");
      log("DATA: ${message.data}");

      _showLocalNotification(message);
    });
  }

  /// CLICK LISTENER (background → opened via tap)
  static void _listenClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification clicked (background)");

      handleNotification(message);
    });
  }

  /// SHOW LOCAL NOTIFICATION (heads-up banner while in foreground)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? "SkillSwap",
      body: message.notification?.body ?? "",
      notificationDetails: details,
      payload: message.data["type"] ?? "",
    );
  }

  /// HANDLE NOTIFICATION NAVIGATION (from RemoteMessage)
  static void handleNotification(RemoteMessage message) {
    String type = message.data["type"] ?? "";
    _navigateByType(type);
  }

  /// Central navigation logic (shared between local-tap and FCM-tap)
  static void _navigateByType(String type) {
    switch (type) {
      case "chat_message":
        log("Open Chat");
        // TODO: navigate to the specific chat screen if needed
        break;

      case "request_accepted":
        log("Open Requests Screen (Accepted)");
        Get.offAll(() => ScreenManager(
              initialIndex: 3,
              initialSessionTab: 0, // Accepted
            ));
        break;

      case "request_rejected":
        log("Request Rejected");
        break;

      case "session_reminder":
        log("Open Session Screen (reminder)");
        break;

      case "session_started":
        log("Open Session Screen (started)");
        break;

      case "rating_request":
        log("Open Session Screen (rating)");
        break;

      case "new_booking":
        log("Open Session Screen (new booking)");
        Get.offAll(() => ScreenManager(
              initialIndex: 3,
              initialSessionTab: 2, // Requests
            ));
        break;

      case "booking_cancelled":
        log("Booking cancelled");
        break;

      default:
        log("Unknown notification type: $type");
    }
  }

  /// LOGOUT – delete token from backend
  static Future<void> deleteToken() async {
    try {
      await sl<NotificationRepository>().deleteFcmToken();
    } catch (e) {
      log("Error deleting FCM token");
    }
  }
}
