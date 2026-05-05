import 'package:hive/hive.dart';

class LocalStorage {
  static const _box = 'appBox';
  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _onboardingKey = 'onboarding';
  static const _userIdKey = 'userId';
  static const _shownDialogsKey = 'shown_join_dialogs';

  static Box get _boxInstance => Hive.box(_box);

  // ================= TOKEN =================

  static Future<void> saveToken(String token) async {
    await _boxInstance.put(_tokenKey, token);
  }

  static String? getToken() {
    return _boxInstance.get(_tokenKey);
  }

  static Future<void> clearToken() async {
    await _boxInstance.delete(_tokenKey);
  }

  // ================= REFRESH TOKEN =================

  static Future<void> saveRefreshToken(String token) async {
    await _boxInstance.put(_refreshTokenKey, token);
  }

  static String? getRefreshToken() {
    return _boxInstance.get(_refreshTokenKey);
  }

  static Future<void> clearAllTokens() async {
    await _boxInstance.delete(_tokenKey);
    await _boxInstance.delete(_refreshTokenKey);
  }

  static bool isLoggedIn() {
    return _boxInstance.get(_tokenKey) != null;
  }

  // ================= ONBOARDING =================

  static Future<void> setOnboardingSeen() async {
    await _boxInstance.put(_onboardingKey, true);
  }

  static bool isOnboardingSeen() {
    return _boxInstance.get(_onboardingKey) ?? false;
  }

  // ================= USER =================

  static Future<void> saveUserId(String userId) async {
    await _boxInstance.put(_userIdKey, userId);
  }

  static String? getUserId() {
    return _boxInstance.get(_userIdKey);
  }

  static Future<void> clearUserId() async {
    await _boxInstance.delete(_userIdKey);
  }

  // ================= DIALOGS =================

  static List<String> getShownDialogs() {
    final data = _boxInstance.get(_shownDialogsKey);
    return data == null ? [] : List<String>.from(data);
  }

  static Future<void> saveShownDialogs(List<String> list) async {
    await _boxInstance.put(_shownDialogsKey, list);
  }
}
