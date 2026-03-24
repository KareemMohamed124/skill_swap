import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/common_ui/screen_manager/screen_manager.dart';
import 'package:skill_swap/shared/core/localization/app_translation.dart';
import 'package:skill_swap/shared/core/localization/language_controller.dart';
import 'package:skill_swap/shared/core/services/notification_service.dart';
import 'package:skill_swap/shared/core/theme/dark_theme.dart';
import 'package:skill_swap/shared/core/theme/light_theme.dart';
import 'package:skill_swap/shared/core/theme/theme_controller.dart';
import 'package:skill_swap/shared/data/quiz/quiz_controller.dart';
import 'package:skill_swap/shared/dependency_injection/injection.dart';
import 'package:skill_swap/shared/helper/local_storage.dart';

import 'desktop/presentation/common/desktop_screen_manager.dart';
import 'desktop/presentation/sign/screens/sign_in_screen.dart';
import 'mobile/presentation/onboarding_screen/screens/onboarding.dart';
import 'mobile/presentation/sign/screens/sign_in_screen.dart';

final GlobalKey<DesktopScreenManagerState> desktopKey =
    GlobalKey<DesktopScreenManagerState>();

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Background Notification Received");

  NotificationService.handleNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Gemini Initialization
  try {
    Gemini.init(apiKey: QuizController.apiKey);
    print("Gemini initialized with API key");
  } catch (e) {
    print("Failed to initialize Gemini: $e");
  }

  // Hive & Storage Initialization
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  await initDependencies();
  await GetStorage.init();
  // Firebase Notification
  await Firebase.initializeApp();
  // background messages
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  // initialize notification service
  await NotificationService.init();
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("New FCM Token: $newToken");
  });
  final isOnboardingSeen = await LocalStorage.isOnboardingSeen();
  final isLogged = await LocalStorage.isLoggedIn();

  Widget startScreen;

  if (!isOnboardingSeen) {
    startScreen = OnBoardingScreen();
  } else if (!isLogged) {
    startScreen = const SignInScreen();
  } else {
    startScreen = LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          return ScreenManager();
        }
        if (constraints.maxWidth >= 800) {
          // Desktop or large screen
          return SignInDesktop();
        }
        return ScreenManager(); // Mobile
      },
    );
  }

  Get.put(ThemeController()..loadSavedTheme());

  // Run App with Device Preview
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(startScreen: startScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.put(LanguageController());

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<MyProfileCubit>()..fetchMyProfile()),
          ],
          child: GetMaterialApp(
            useInheritedMediaQuery: true,
            builder: DevicePreview.appBuilder,
            title: 'SkillSwap',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: controller.themeMode,
            translations: AppTranslation(),
            locale: langController.initialLanguage,
            fallbackLocale: const Locale("en", "US"),
            home: startScreen,
          ),
        );
      },
    );
  }
}
