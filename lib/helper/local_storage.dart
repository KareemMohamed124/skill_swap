// lib/helper/local_storage.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/user/user_model.dart';

class LocalStorage {
  static const _boxName = 'appBox';

  static const _userKey = 'user';
  static const _loggedInKey = 'is_logged_in';
  static const _onboardingKey = 'onboarding_seen';

  /// ================= INIT =================
  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  /// ================= ONBOARDING =================
  static Future<void> setOnboardingSeen() async {
    final box = Hive.box(_boxName);
    await box.put(_onboardingKey, true);
  }

  static bool isOnboardingSeen() {
    final box = Hive.box(_boxName);
    return box.get(_onboardingKey, defaultValue: false);
  }

  /// ================= LOGIN FLAG =================
  static Future<void> setLoggedIn(bool value) async {
    final box = Hive.box(_boxName);
    await box.put(_loggedInKey, value);
  }

  static bool isLoggedIn() {
    final box = Hive.box(_boxName);
    return box.get(_loggedInKey, defaultValue: false);
  }

  /// ================= SAVE USER =================
  static Future<void> saveUser(UserModel user) async {
    final box = Hive.box(_boxName);
    await box.put(_userKey, user.toJson());
  }

  /// ================= GET USER =================
  static UserModel? getUser() {
    final box = Hive.box(_boxName);
    final data = box.get(_userKey);
    if (data == null) return null;

    return UserModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  /// ================= CREATE USER (SIGN UP) =================
  static Future<void> createUser({
    required String id,
    required String name,
    required String email,
  }) async {
    final user = UserModel(
      id: id,
      name: name,
      email: email,
      imagePath: null,
    );

    await saveUser(user);
    await setLoggedIn(true);
  }

  /// ================= UPDATE IMAGE =================
  static Future<void> updateUserImage(String imagePath) async {
    final user = getUser();
    if (user == null) return;

    final updatedUser = user.copyWith(imagePath: imagePath);
    await saveUser(updatedUser);
  }

  /// ================= UPDATE NAME / EMAIL =================
  static Future<void> updateUser({
    String? name,
    String? email,
  }) async {
    final user = getUser();
    if (user == null) return;

    final updatedUser = user.copyWith(
      name: name ?? user.name,
      email: email ?? user.email,
    );
    await saveUser(updatedUser);
  }

  /// ================= SIGN OUT =================
  static Future<void> signOut() async {
    final box = Hive.box(_boxName);
    await box.put(_loggedInKey, false);
    // ❗ متلمسيش user
  }
  /// ================= UPDATE IMAGE =================
  static Future<void> saveUserImage(String imagePath) async {
    final user = await getUser();
    if (user == null) return;

    final updatedUser = user.copyWith(imagePath: imagePath);
    await saveUser(updatedUser);
  }
  /// ================= GET USER BY EMAIL =================
  static Future<UserModel?> getUserByEmail(String email) async {
    final box = await Hive.openBox(_boxName);
    final data = box.get(_userKey);
    if (data == null) return null;

    final user = UserModel.fromJson(Map<String, dynamic>.from(data));
    if (user.email == email) return user;
    return null;
  }
}