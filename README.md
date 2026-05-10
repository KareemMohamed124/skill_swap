# SkillSwap

**SkillSwap** is a cross-platform skill-sharing and mentorship application built with Flutter. It connects users who want to exchange knowledge through text chats, video calls, and scheduled sessions. The app features real-time messaging (via Pusher), AI-powered skill verification quizzes (via Google Gemini), session booking & management, a gamified leaderboard, an in-app store, push notifications, and multi-language support.

---

## Table of Contents

- [Prerequisites and Dependencies](#prerequisites-and-dependencies)
- [Installation Steps](#installation-steps)
- [Compilation Steps](#compilation-steps)
- [Run Instructions](#run-instructions)
- [Environment Setup & Configuration](#environment-setup--configuration)
- [Project Structure](#project-structure)

---

## Prerequisites and Dependencies

### Programming Languages & Versions

| Language | Version |
|----------|---------|
| **Dart** | `>= 3.3.0 < 4.0.0` |
| **Kotlin** | JDK 8 target (Android native) |

### Frameworks

| Framework | Version |
|-----------|---------|
| **Flutter SDK** | `>= 3.19.0` (stable channel recommended) |

> **Verify with:** `flutter --version` and `dart --version`

### Required Software & Tools

| Tool | Purpose | Download |
|------|---------|----------|
| **Flutter SDK** | Core framework | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Android Studio** | Android build toolchain & emulators | [developer.android.com/studio](https://developer.android.com/studio) |
| **Android SDK** | Compile SDK 36, NDK `28.2.13676358` | Installed via Android Studio SDK Manager |
| **Xcode** *(macOS only)* | iOS/macOS builds | Mac App Store |
| **Visual Studio** *(Windows only)* | Windows desktop builds (C++ workload) | [visualstudio.microsoft.com](https://visualstudio.microsoft.com/) |
| **Git** | Version control | [git-scm.com](https://git-scm.com/) |
| **Firebase CLI** | Firebase project management | `npm install -g firebase-tools` |
| **FlutterFire CLI** | Firebase configuration for Flutter | `dart pub global activate flutterfire_cli` |

### System Requirements

| Platform | Minimum Requirements |
|----------|---------------------|
| **Windows** | Windows 10 or later, 8 GB RAM, 4 GB disk space |
| **macOS** | macOS 12 (Monterey) or later, 8 GB RAM |
| **Android** | Min SDK set by Flutter (API 21+), Target SDK 36 |
| **iOS** | iOS 12.0+ |

### External Services & APIs

| Service | Purpose | Required |
|---------|---------|----------|
| **SkillSwap Backend API** | Core REST API (`https://skill-swaapp.vercel.app`) | ✅ Yes |
| **Firebase** | Authentication, Cloud Firestore (WebRTC signaling), Push Notifications (FCM) | ✅ Yes |
| **Pusher Channels** | Real-time messaging (App Key: configured in code, Cluster: `mt1`) | ✅ Yes |
| **Google Gemini AI** | AI-powered skill verification quizzes | ✅ Yes |

### Key Flutter Packages

<details>
<summary>Click to expand full dependency list</summary>

**State Management:**
- `flutter_bloc` / `bloc` — BLoC pattern
- `get` — Navigation & state (GetX)
- `get_it` — Dependency injection
- `equatable` — Value equality

**Networking:**
- `dio` — HTTP client
- `retrofit` — Type-safe REST API layer
- `json_annotation` / `json_serializable` — JSON serialization
- `jwt_decoder` — JWT token parsing
- `connectivity_plus` / `internet_connection_checker_plus` — Network monitoring
- `pusher_channels_flutter` — Real-time Pusher integration

**Local Storage:**
- `hive` / `hive_flutter` — NoSQL local database
- `get_storage` — Key-value storage

**Firebase:**
- `firebase_core` — Firebase initialization
- `firebase_messaging` — Push notifications (FCM)
- `cloud_firestore` — Firestore (video call signaling)
- `flutter_local_notifications` — Local notification display

**Video Call:**
- `flutter_webrtc` — Peer-to-peer video calling

**AI:**
- `google_generative_ai` / `flutter_gemini` — Google Gemini integration

**UI Libraries:**
- `smooth_page_indicator`, `carousel_slider_plus`, `iconsax_flutter`, `lottie`, `table_calendar`, `font_awesome_flutter`, and more

</details>

---

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/KareemMohamed124/skill_swap.git
cd skill_swap
```

### 2. Verify Flutter Installation

```bash
flutter doctor -v
```

Ensure there are **no critical issues** for your target platform (Android / iOS / Windows / Web).

### 3. Install Flutter Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

The project already includes pre-configured Firebase options in `lib/firebase_options.dart`. If you need to reconfigure for your own Firebase project:

```bash
# Install FlutterFire CLI (if not installed)
dart pub global activate flutterfire_cli

# Log in to Firebase
firebase login

# Configure Firebase for the project
flutterfire configure --project=skill-swap-e1a3d
```

This generates/updates:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist` *(if targeting iOS)*

### 5. Generate Code (Retrofit, JSON Serialization)

The project uses `build_runner` for code generation (Retrofit API clients, JSON models):

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Set Up Android Signing *(Android only)*

For release builds, the project is configured with debug signing by default. For production:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `android/key.properties`:
   ```properties
   storePassword=<your-password>
   keyPassword=<your-password>
   keyAlias=upload
   storeFile=<path-to-keystore>/upload-keystore.jks
   ```

---

## Compilation Steps

### Android (APK / App Bundle)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Release App Bundle (for Google Play)
flutter build appbundle --release
```

### iOS *(macOS only)*

```bash
# Install CocoaPods dependencies
cd ios && pod install && cd ..

# Build for iOS
flutter build ios --release
```

### Windows Desktop

```bash
flutter build windows --release
```

### Web

```bash
flutter build web --release
```

### Generate Native Splash Screen

```bash
dart run flutter_native_splash:create
```

### Generate App Launcher Icons

```bash
dart run flutter_launcher_icons
```

---

## Run Instructions

### Run in Debug Mode (Development)

```bash
# Auto-detect connected device
flutter run

# Specify a target device
flutter devices                  # List available devices
flutter run -d <device-id>       # Run on specific device

# Run on Chrome (Web)
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows

# Run on Android Emulator
flutter run -d emulator-5554
```

### Run with Hot Reload

Once the app is running in debug mode, press:
- **`r`** — Hot reload (preserves state)
- **`R`** — Hot restart (resets state)
- **`q`** — Quit

### Run Release Mode (Optimized)

```bash
flutter run --release
```

### Deploy Web to Firebase Hosting

```bash
flutter build web --release
firebase deploy --only hosting
```

---

## Environment Setup & Configuration

### API Configuration

The backend API base URL is hardcoded across the API service files. The primary endpoint is:

```
https://skill-swaapp.vercel.app
```

This is referenced in the following files:
- `lib/shared/data/web_services/user/user_api.dart`
- `lib/shared/data/web_services/chat/chat_api_service.dart`
- `lib/shared/data/web_services/store/store_api_service.dart`
- `lib/shared/data/web_services/skills/skills_api_services.dart`
- `lib/shared/data/web_services/booking/booking_api.dart`
- `lib/shared/data/web_services/notification/notification_api.dart`
- `lib/shared/data/web_services/report/report_api.dart`

> **To change the API endpoint**, update the `baseUrl` / `_baseUrl` constant in each of these files.

### Pusher (Real-time Messaging)

Pusher is configured in `lib/shared/core/network/pusher_service.dart`:

```dart
static const String _appKey = 'e3ac92c762aaed1a23ae';
static const String _cluster = 'mt1';
```

If using your own Pusher account, update these values with your own App Key and Cluster.

### Google Gemini AI (Skill Quizzes)

The Gemini API key is configured in `lib/shared/data/quiz/quiz_controller.dart`:

```dart
static const apiKey = "AIzaSyCNE3eSwqFxqijj5KCA3aEaydNA4buFSPs";
```

To use your own key:
1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Generate a new API key
3. Replace the value in `quiz_controller.dart`

### Firebase Configuration

Firebase is auto-configured via `lib/firebase_options.dart` for the following platforms:

| Platform | Status |
|----------|--------|
| Android  | ✅ Configured |
| iOS      | ✅ Configured |
| macOS    | ✅ Configured |
| Web      | ✅ Configured |
| Windows  | ✅ Configured |
| Linux    | ❌ Not configured |

**Firebase Project ID:** `skill-swap-e1a3d`

The project uses:
- **Cloud Firestore** — Video call signaling (WebRTC)
- **Firebase Cloud Messaging (FCM)** — Push notifications
- **Firebase Hosting** — Web deployment

### Local Storage

The app uses **Hive** for local storage (tokens, user preferences, onboarding state). Data is stored in the application documents directory and initialized at app startup:

```dart
final dir = await getApplicationDocumentsDirectory();
await Hive.initFlutter(dir.path);
await Hive.openBox('appBox');
```

No manual database setup is needed — Hive creates its storage files automatically on first run.

### Authentication

The app uses **JWT-based authentication**. Tokens are stored locally via Hive and automatically attached to API requests through `AuthInterceptor` (`lib/shared/core/network/auth_interceptor.dart`):

```
Authorization: skill-swap <token>
```

The interceptor handles:
- Token expiration → auto-logout
- Duplicate login detection → force logout
- Account blocking → force logout

### Android-Specific Configuration

**`android/app/build.gradle.kts`:**
- `compileSdk = 36` / `targetSdk = 36`
- `minSdk` = Flutter default (API 21)
- ProGuard enabled for release builds
- Core library desugaring enabled

**Required `google-services.json`:** Must be placed at `android/app/google-services.json` (generated by FlutterFire CLI).

---

## Project Structure

```
lib/
├── main.dart                        # App entry point
├── firebase_options.dart            # Firebase config (auto-generated)
├── mobile/                          # Mobile-specific UI
│   └── presentation/               # Screens (22 feature modules)
│       ├── home/                    # Home screen
│       ├── chat_channel/            # Public chat channels
│       ├── prv_chat/                # Private chat
│       ├── video_call/              # Video call (WebRTC)
│       ├── book_session/            # Session booking
│       ├── sessions/                # Session management
│       ├── search/                  # Mentor search
│       ├── profile/                 # User profile
│       ├── setting/                 # App settings
│       ├── sign/                    # Sign in / Sign up
│       ├── skill_verification/      # AI quiz verification
│       ├── game_part/               # Gamification
│       ├── game_stor/               # In-app store
│       └── ...                      # Other feature modules
├── desktop/                         # Desktop-specific UI (Windows)
│   └── presentation/               # Desktop screens (18 feature modules)
└── shared/                          # Shared code (cross-platform)
    ├── bloc/                        # BLoC/Cubit state management
    ├── core/
    │   ├── network/                 # Dio interceptor, Pusher service
    │   ├── services/                # Notification service
    │   ├── theme/                   # Theme management
    │   ├── localization/            # Multi-language support
    │   └── utils/                   # Utilities
    ├── data/
    │   ├── models/                  # Data models
    │   ├── repositories/            # Repository implementations
    │   ├── web_services/            # API service layers (Retrofit)
    │   └── quiz/                    # Gemini AI quiz controller
    ├── domain/
    │   └── repositories/            # Repository interfaces
    ├── dependency_injection/        # GetIt DI setup
    ├── helper/                      # Local storage helper
    ├── common_ui/                   # Shared UI components
    ├── constants/                   # App constants & static data
    └── lang/                        # Language files
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `flutter pub get` fails | Run `flutter clean` then `flutter pub get` |
| Build runner errors | `dart run build_runner build --delete-conflicting-outputs` |
| Firebase init fails | Ensure `google-services.json` exists in `android/app/` |
| Android build fails (SLF4J) | Already fixed — SLF4J dependencies included in `build.gradle.kts` |
| Pusher not connecting | Verify network connectivity and Pusher credentials |
| WebRTC crash on desktop | `WebRTC.initialize()` is called in `main.dart` — ensure it runs before camera access |
| iOS pod install fails | `cd ios && pod install --repo-update && cd ..` |

---

## License

This project is developed as a graduation project and is not currently published under a specific open-source license.
