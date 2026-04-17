// import 'dart:developer';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
//
// import '../../common_ui/screen_manager/screen_manager.dart';
// import '../../dependency_injection/injection.dart';
// import '../../domain/repositories/notification_repository.dart';
//
// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();
//
//   /// INIT
//   static Future<void> init() async {
//     await _requestPermission();
//
//     await _initLocalNotifications();
//
//     await _registerToken();
//
//     _listenForeground();
//
//     _listenClick();
//
//     _listenTokenRefresh();
//
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       handleNotification(initialMessage);
//     }
//   }
//
//   /// REQUEST PERMISSION
//   static Future<void> _requestPermission() async {
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     log("Notification Permission: ${settings.authorizationStatus}");
//   }
//
//   /// GET TOKEN + SEND TO BACKEND
//   static Future<void> _registerToken() async {
//     String? token = await _messaging.getToken();
//
//     log("FCM TOKEN: $token");
//
//     if (token == null) return;
//
//     try {
//       await sl<NotificationRepository>().saveFcmToken(token);
//       log("FCM token sent to backend");
//     } catch (e) {
//       log("Error sending FCM token: $e");
//     }
//   }
//
//   /// TOKEN REFRESH
//   static void _listenTokenRefresh() {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//       log("New FCM TOKEN: $newToken");
//
//       try {
//         await sl<NotificationRepository>().saveFcmToken(newToken);
//       } catch (e) {
//         log("Error updating token");
//       }
//     });
//   }
//
//   /// INIT LOCAL NOTIFICATION
//   static Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings android =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//         InitializationSettings(android: android);
//
//     await _localNotifications.initialize(
//       settings: settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         log("Notification clicked (local)");
//       },
//     );
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'channel_id',
//       'General Notifications',
//       importance: Importance.max,
//     );
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
//
//   /// FOREGROUND
//   static void _listenForeground() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log("FOREGROUND MESSAGE ARRIVED");
//       log("NOTIFICATION: ${message.notification}");
//       log("DATA: ${message.data}");
//
//       _showLocalNotification(message);
//     });
//   }
//
//   /// CLICK LISTENER
//   static void _listenClick() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("Notification clicked");
//
//       handleNotification(message);
//     });
//   }
//
//   /// SHOW LOCAL NOTIFICATION
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       "channel_id",
//       "General Notifications",
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails details =
//         NotificationDetails(android: androidDetails);
//
//     await _localNotifications.show(
//       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title: message.notification?.title ?? "SkillSwap",
//       body: message.notification?.body ?? "",
//       notificationDetails: details,
//       payload: message.data["type"] ?? "",
//     );
//   }
//
//   /// HANDLE NOTIFICATION NAVIGATION
//   static void handleNotification(RemoteMessage message) {
//     String type = message.data["type"] ?? "";
//
//     switch (type) {
//       case "chat_message":
//         String chatId = message.data["chat_id"] ?? "";
//         log("Open Chat: $chatId");
//         break;
//
//       case "request_accepted":
//         log("Open Requests Screen");
//         Get.offAll(() => ScreenManager(
//               initialIndex: 3,
//               initialSessionTab: 0, // Accepted
//             ));
//         break;
//
//       case "request_rejected":
//         log("Request Rejected");
//         break;
//
//       case "session_reminder":
//         log("Open Session Screen");
//         break;
//
//       case "session_started":
//         log("Open Session Screen");
//         break;
//
//       case "rating_request":
//         log("Open Session Screen");
//         break;
//
//       case "new_booking":
//         log("Open Session Screen");
//         Get.offAll(() => ScreenManager(
//               initialIndex: 3,
//               initialSessionTab: 2, // Requests
//             ));
//         break;
//
//       case "booking_cancelled":
//         log("Open Session Screen");
//         break;
//
//       default:
//         log("Unknown notification type");
//     }
//   }
//
//   /// LOGOUT
//   static Future<void> deleteToken() async {
//     try {
//       await sl<NotificationRepository>().deleteFcmToken();
//     } catch (e) {
//       log("Error deleting FCM token");
//     }
//   }
// }
