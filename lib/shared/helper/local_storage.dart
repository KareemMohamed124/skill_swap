import 'package:hive/hive.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

class LocalStorage {
  static const _box = 'appBox';
  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _onboardingKey = 'onboarding';
  static const _userIdKey = 'userId';
  static const _userKey = "user";

  static Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_box);
    await box.put(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final box = await Hive.openBox(_box);
    return box.get(_tokenKey);
  }

  static Future<void> clearToken() async {
    final box = await Hive.openBox(_box);
    await box.delete(_tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    final box = await Hive.openBox(_box);
    await box.put(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final box = await Hive.openBox(_box);
    return box.get(_refreshTokenKey);
  }

  static Future<void> clearAllTokens() async {
    final box = await Hive.openBox(_box);
    await box.delete(_tokenKey);
    await box.delete(_refreshTokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final box = await Hive.openBox(_box);
    return box.get(_tokenKey) != null;
  }

  // Onboarding
  static Future<void> setOnboardingSeen() async {
    final box = await Hive.openBox(_box);
    await box.put(_onboardingKey, true);
  }

  static Future<bool> isOnboardingSeen() async {
    final box = await Hive.openBox(_box);
    return box.get(_onboardingKey) ?? false;
  }

  static Future<void> saveUserId(String userId) async {
    final box = await Hive.openBox(_box);
    await box.put(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final box = await Hive.openBox(_box);
    return box.get(_userIdKey);
  }

  static Future<void> clearUserId() async {
    final box = await Hive.openBox(_box);
    await box.delete(_userIdKey);
  }

  static Future<void> saveUser(MyProfile user) async {
    final box = await Hive.openBox(_box);
    await box.put(_userKey, user.toJson());
  }

  static Future<MyProfile?> getUser() async {
    final box = await Hive.openBox(_box);
    final data = box.get(_userKey);
    if (data == null) return null;
    return MyProfile.fromJson(Map<String, dynamic>.from(data));
  }

  static Future<void> clearUser() async {
    final box = await Hive.openBox(_box);
    await box.delete(_userKey);
  }
}
