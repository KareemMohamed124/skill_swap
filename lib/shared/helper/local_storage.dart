import 'package:hive/hive.dart';

import '../data/models/user/user_model.dart';

class LocalStorage {
  static const _box = 'appBox';
  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _onboardingKey = 'onboarding';

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

  static Future<void> setOnboardingSeen() async {
    final box = await Hive.openBox(_box);
    await box.put(_onboardingKey, true);
  }

  static Future<bool> isOnboardingSeen() async {
    final box = await Hive.openBox(_box);
    return box.get(_onboardingKey) ?? false;
  }

  static const _userKey = "user";

  static Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox(_box);
    await box.put(_userKey, user.toJson());
  }

  static Future<UserModel?> getUser() async {
    final box = await Hive.openBox(_box);
    final data = box.get(_userKey);
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }
}
