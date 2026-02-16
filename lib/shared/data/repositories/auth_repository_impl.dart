import 'package:dio/dio.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/delete_account/delete_account_response.dart';
import '../models/login/login_error_response.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../models/register/register_error_response.dart';
import '../models/register/register_request.dart';
import '../models/register/register_response.dart';
import '../models/reset_password/reset_password_error_response.dart';
import '../models/reset_password/reset_password_request.dart';
import '../models/reset_password/reset_password_response.dart';
import '../models/send_code/send_code_error_response.dart';
import '../models/send_code/send_code_request.dart';
import '../models/send_code/send_code_response.dart';
import '../models/verify_code/verify_code_error_response.dart';
import '../models/verify_code/verify_code_request.dart';
import '../models/verify_code/verify_code_response.dart';
import '../../helper/local_storage.dart';
import '../web_services/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  final Dio dio;

  AuthRepositoryImpl({required this.api, required this.dio});

  @override
  Future<void> logout() async {
    try {
      await api.logout();
    } catch (_) {
      // Even if the API call fails, clear tokens locally
    } finally {
      await LocalStorage.clearAllTokens();
    }
  }

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await api.register(request);
      if (response.message ==
          "User Registered Successfully. Please check you email for activation code") {
        return RegisterSuccess(response);
      }
      return RegisterFailure(RegisterErrorResponse(message: response.message));
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = RegisterErrorResponse.fromJson(e.response!.data);
        return RegisterFailure(error);
      }

      return RegisterFailure(
        RegisterErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return RegisterFailure(
        RegisterErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await api.login(request);
      if (response.message == "User Login Successfully") {
        return LoginSuccess(response);
      }
      return LoginFailure(LoginErrorResponse(message: response.message));
    } on DioException catch (e) {
      final msg = _getServerErrorMessage(e);
      return LoginFailure(LoginErrorResponse(message: msg));
    } catch (e) {
      return LoginFailure(LoginErrorResponse(message: e.toString()));
    }
  }

  @override
  Future<SendCodeResponse> sendCode(SendCodeRequest request) async {
    try {
      final response = await api.sendCode(request);
      if (response.message == "Verification Code Sent Successfully") {
        return SendCodeSuccess(response);
      }
      return SendCodeFailure(SendCodeErrorResponse(message: response.message));
    } on DioException catch (e) {
      return SendCodeFailure(
        SendCodeErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return SendCodeFailure(
        SendCodeErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request) async {
    try {
      final response = await api.verifyCode(request);
      if (response.message == "Code Verified Successfully") {
        return VerifyCodeSuccess(response);
      }
      return VerifyCodeFailure(
        VerifyCodeErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      return VerifyCodeFailure(
        VerifyCodeErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return VerifyCodeFailure(VerifyCodeErrorResponse(message: e.toString()));
    }
  }

  @override
  Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final response = await api.resetPassword(request);
      if (response.message == 'Password Changed Successfully') {
        return ResetPasswordSuccess(response);
      }
      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = ResetPasswordErrorResponse.fromJson(e.response!.data);
        return ResetPasswordFailure(error);
      }

      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<DeleteAccountResponse> deleteAccount() async {
    try {
      await api.deleteAccount();
      await LocalStorage.clearAllTokens();
      return DeleteAccountSuccess();
    } on DioException catch (e) {
      return DeleteAccountFailure(_getServerErrorMessage(e));
    } catch (e) {
      return DeleteAccountFailure(e.toString());
    }
  }

  @override
  Future<void> verifyActivation(String code) async {
    try {
      await api.verifyActivation({'activation_code': code});
    } on DioException catch (e) {
      throw _getServerErrorMessage(e);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> resendActivation(String email) async {
    try {
      await api.resendActivation({'email': email});
    } on DioException catch (e) {
      throw _getServerErrorMessage(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
