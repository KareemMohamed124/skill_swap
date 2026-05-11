import 'package:hive/hive.dart';
<<<<<<< HEAD
=======
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class LocalStorage {
  static const _box = 'appBox';
  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _onboardingKey = 'onboarding';
  static const _userIdKey = 'userId';
<<<<<<< HEAD
  static const _trackKey = 'track';
  static const _skillsKey = 'skills';
  static const _isActiveKey = 'isActive';
  static const _shownDialogsKey = 'shown_join_dialogs';
  static const _emailKey = 'email';

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

  static Future<void> saveUserTrack(String track) async {
    await _boxInstance.put(_trackKey, track);
  }

  static String? getUserTrack() {
    return _boxInstance.get(_trackKey);
  }

  static Future<void> saveUserSkills(List<String> skills) async {
    await _boxInstance.put(_skillsKey, skills);
  }

  static List<String> getUserSkills() {
    final data = _boxInstance.get(_skillsKey);

    if (data == null) return [];

    return List<String>.from(data);
  }

  static Future<void> saveIsActive(bool isActive) async {
    await _boxInstance.put(_isActiveKey, isActive);
  }

  static bool getIsActive() {
    return _boxInstance.get(_isActiveKey) ?? false;
  }

  // ================= EMAIL =================

  static Future<void> saveEmail(String email) async {
    await _boxInstance.put(_emailKey, email);
  }

  static String? getEmail() {
    return _boxInstance.get(_emailKey);
  }

  static Future<void> clearEmail() async {
    await _boxInstance.delete(_emailKey);
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }
}
