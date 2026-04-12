import 'dart:io';

import 'package:device_preview/device_preview.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Project
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

// Zego
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'desktop/presentation/common/desktop_screen_manager.dart';
import 'desktop/presentation/sign/screens/sign_in_screen.dart';
import 'mobile/presentation/onboarding_screen/screens/onboarding.dart';
import 'mobile/presentation/sign/screens/sign_in_screen.dart';
import 'mobile/presentation/video_call/LiveKeys.dart';

final GlobalKey<DesktopScreenManagerState> desktopKey =
    GlobalKey<DesktopScreenManagerState>();

// ==========================
// Firebase Background
// ==========================
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  if (!kIsWeb && Platform.isAndroid) {
    await Firebase.initializeApp();
  }
}

// ==========================
// MAIN
// ==========================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gemini
  try {
    Gemini.init(apiKey: QuizController.apiKey);
  } catch (_) {}

  // Local storage
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  await initDependencies();
  await GetStorage.init();

  final userId = await LocalStorage.getUserId();
  const userName = 'User';

  // ==========================
  // ANDROID ONLY SERVICES
  // ==========================
  if (!kIsWeb && Platform.isAndroid) {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    await NotificationService.init();

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: LiveKeys.appId,
      appSign: LiveKeys.appSign,
      userID: userId ?? '',
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

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
        if (kIsWeb) return ScreenManager();

        if (constraints.maxWidth >= 800) {
          return SignInDesktop();
        }

        return ScreenManager();
      },
    );
  }

  Get.put(ThemeController()..loadSavedTheme());

  runApp(
    DevicePreview(
      enabled: kDebugMode, // 🔥 مهم جدًا
      builder: (context) => MyApp(startScreen: startScreen),
    ),
  );
}

// ==========================
// APP ROOT
// ==========================
class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController());

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
            ),
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
