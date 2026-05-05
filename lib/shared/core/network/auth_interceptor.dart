import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../helper/local_storage.dart';

/// Dio interceptor that:
/// 1. Attaches the access token to every request.
/// 2. On a 401 response, attempts to refresh the token using the refresh token.
/// 3. Retries the original failed request with the new access token.
/// 4. If refresh fails, shows a session expired dialog and navigates to the sign-in screen.

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  // ───────────────────── onRequest ─────────────────────
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'skill-swap $token';
    }

    handler.next(options);
  }

  // ───────────────────── onResponse ─────────────────────
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data.toString();

    if (_isTokenExpired(data)) {
      print('🚨 Token expired (response)');
      _showSessionExpiredDialog();
    }

    handler.next(response);
  }

  // ───────────────────── onError ─────────────────────
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final data = err.response?.data.toString() ?? '';

    print('❗ Error Data: $data');

    if (_isTokenExpired(data)) {
      print('🚨 Token expired (error)');
      _showSessionExpiredDialog();
    }

    handler.next(err);
  }

  // ───────────────────── Helpers ─────────────────────

  bool _isTokenExpired(String data) {
    return data.contains('jwt expired') || data.contains('TokenExpiredError');
  }

  Future<void> _showSessionExpiredDialog() async {
    await LocalStorage.clearAllTokens();

    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Session Expired'),
        content: const Text('Your session has expired. Please log in again.'),
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
  }
}
