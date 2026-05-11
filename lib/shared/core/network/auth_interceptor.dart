import 'dart:async';

import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:get/get.dart' hide Response;

import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../helper/local_storage.dart';

<<<<<<< HEAD
class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  // ───────────────────── REQUEST ─────────────────────
=======
/// Dio interceptor that:
/// 1. Attaches the access token to every request.
/// 2. On a 401 response, attempts to refresh the token using the refresh token.
/// 3. Retries the original failed request with the new access token.
/// 4. If refresh fails, clears tokens and navigates to the sign-in screen.
class AuthInterceptor extends Interceptor {
  final Dio dio;

  /// A separate Dio instance used only for refreshing tokens,
  /// to avoid interceptor recursion.
  final Dio _refreshDio = Dio();

  /// Completer to coordinate concurrent 401 responses —
  /// only one refresh request is made at a time.
  Completer<bool>? _refreshCompleter;

  AuthInterceptor(this.dio);

  // ───────────────────── onRequest ─────────────────────
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorage.getToken();
<<<<<<< HEAD

    if (token != null) {
      options.headers['Authorization'] = 'skill-swap $token';
    }

    handler.next(options);
  }

  // ───────────────────── RESPONSE ─────────────────────
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final message = _extractMessage(response.data);
    final statusCode = response.statusCode ?? 0;

    await _handleAllCases(
      statusCode: statusCode,
      message: message,
      isError: false,
    );

    handler.next(response);
  }

  // ───────────────────── ERROR ─────────────────────
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final message = _extractMessage(err.response?.data);
    final statusCode = err.response?.statusCode ?? 0;

    print('❌ STATUS: $statusCode');
    print('❌ MESSAGE: $message');
    print('❌ TYPE: ${err.type}');

    await _handleAllCases(
      statusCode: statusCode,
      message: message,
      isError: true,
      dioErrorType: err.type,
    );

    handler.next(err);
  }

  // ───────────────────── MAIN HANDLER ─────────────────────
  Future<void> _handleAllCases({
    required int statusCode,
    required String message,
    required bool isError,
    DioExceptionType? dioErrorType,
  }) async {
    // =========================
    // FORCE LOGOUT CASES (SECURITY)
    // =========================

    if (_isTokenExpired(message)) {
      await _logout(
        title: 'Session Expired',
        message: 'Please login again.',
      );
      return;
    }

    if (_isAnotherLogin(message)) {
      await _logout(
        title: 'Logged Out',
        message: 'Your account was used on another device.',
      );
      return;
    }

    if (_isBlocked(message)) {
      await _logout(
        title: 'Account Blocked',
        message: message,
      );
      return;
    }

    // =========================
    // INTERNET / NETWORK ISSUES
    // =========================

    if (dioErrorType != null) {
      if (dioErrorType == DioExceptionType.connectionError) {
        await _logout(
          title: 'Connection Lost',
          message: 'No internet connection. Please login again.',
        );
        return;
      }
    }

    // // =========================
    // // SERVER ERROR
    // // =========================
    //
    // if (statusCode >= 500) {
    //   await _logout(
    //     title: 'Server Error',
    //     message: 'Server is down. Please try again later.',
    //   );
    //   return;
    // }
  }

  // ───────────────────── HELPERS ─────────────────────

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? '';
    }
    return data?.toString() ?? '';
  }

  bool _isTokenExpired(String msg) {
    return msg.contains('jwt expired') || msg.contains('TokenExpiredError');
  }

  bool _isAnotherLogin(String msg) {
    return msg.contains('Another login detected') ||
        msg.contains('Session expired');
  }

  bool _isBlocked(String msg) {
    return msg.contains('blocked');
  }

  // ───────────────────── LOGOUT ─────────────────────

  Future<void> _logout({
    required String title,
    required String message,
  }) async {
    await LocalStorage.clearAllTokens();

    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAll(() => const SignInScreen());
            },
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
        Get.offAll(() => const SignInScreen());
      }
    });
=======
    print('🟡 [AuthInterceptor] Request: ${options.method} ${options.uri}');
    print('🟡 [AuthInterceptor] Token present: ${token != null}');
    if (token != null) {
      options.headers['Authorization'] = 'skill-swap $token';
    }
    handler.next(options);
  }

  // ───────────────────── onError ─────────────────────
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh for login/register/refresh requests themselves
    final path = err.requestOptions.path;
    if (path.contains('login') ||
        path.contains('register') ||
        path.contains('refresh')) {
      return handler.next(err);
    }

    // If a refresh is already in progress, wait for it
    if (_refreshCompleter != null) {
      final success = await _refreshCompleter!.future;
      if (success) {
        return handler.resolve(await _retryRequest(err.requestOptions));
      } else {
        return handler.next(err);
      }
    }

    // Start a new refresh attempt
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await LocalStorage.getRefreshToken();
      if (refreshToken == null) {
        _refreshCompleter!.complete(false);
        _refreshCompleter = null;
        await _forceLogout();
        return handler.next(err);
      }

      // Attempt to refresh the access token
      final response = await _refreshDio.post(
        'https://skill-swaapp.vercel.app/auth/refresh/',
        options: Options(
          headers: {'Authorization': 'skill-swap $refreshToken'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['access_token'] as String;
        final newRefreshToken =
            response.data['refresh_token'] as String? ?? refreshToken;

        // Persist the new tokens
        await LocalStorage.saveToken(newAccessToken);
        await LocalStorage.saveRefreshToken(newRefreshToken);

        _refreshCompleter!.complete(true);
        _refreshCompleter = null;

        // Retry the original request with the new token
        return handler.resolve(await _retryRequest(err.requestOptions));
      } else {
        _refreshCompleter!.complete(false);
        _refreshCompleter = null;
        await _forceLogout();
        return handler.next(err);
      }
    } catch (e) {
      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      await _forceLogout();
      return handler.next(err);
    }
  }

  // ───────────────────── Helpers ─────────────────────

  /// Retry the original request using the new access token.
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final token = await LocalStorage.getToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'skill-swap $token',
      },
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Clear all tokens and navigate to the sign-in screen.
  Future<void> _forceLogout() async {
    await LocalStorage.clearAllTokens();
    Get.offAll(() => const SignInScreen());
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }
}
