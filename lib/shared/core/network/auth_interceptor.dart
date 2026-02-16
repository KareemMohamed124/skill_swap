import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../helper/local_storage.dart';

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
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
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
          headers: {'Authorization': 'Bearer $refreshToken'},
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
        'Authorization': 'Bearer $token',
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
  }
}
