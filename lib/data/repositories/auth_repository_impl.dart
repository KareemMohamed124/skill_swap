import 'package:dio/dio.dart';
import 'package:skill_swap/data/models/reset_password/reset_password_error_response.dart';
import 'package:skill_swap/data/models/reset_password/reset_password_request.dart';
import 'package:skill_swap/data/models/reset_password/reset_password_response.dart';
import 'package:skill_swap/data/models/verify_code/verify_code_request.dart';
import 'package:skill_swap/data/models/verify_code/verify_code_response.dart';
import '../../helper/local_storage.dart';
import '../models/login/login_error_response.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../models/register/register_request.dart';
import '../models/register/register_error_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/register/register_response.dart';
import '../models/send_code/send_code_error_response.dart';
import '../models/send_code/send_code_request.dart';
import '../models/send_code/send_code_response.dart';
import '../models/user/user_model.dart';
import '../models/verify_code/verify_code_error_response.dart';
import '../web_services/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  final Dio dio;

  AuthRepositoryImpl({required this.api, required this.dio});

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
      if (response.message == "User Registered Successfully") {
        return RegisterSuccess(response);
      }
      return RegisterFailure(RegisterErrorResponse(message: response.message));
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        final error =
        RegisterErrorResponse.fromJson(e.response!.data);
        return RegisterFailure(error);
      }

      return RegisterFailure(
        RegisterErrorResponse(message: _getServerErrorMessage(e)),
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
      ResetPasswordRequest request,
      ) async {
    try {
      final response = await api.resetPassword(request);
      if (response.message == 'Password Changed Successfully') {
        return ResetPasswordSuccess(response);
      }
      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        final error =
        ResetPasswordErrorResponse.fromJson(e.response!.data);
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
  //
  // @override
  // Future<UserModel> getProfile() async {
  //   final token = await LocalStorage.getToken();
  //   if (token == null) {
  //     throw Exception("User not logged in");
  //   }
  //
  //   final response = await dio.get(
  //     "https://skill-swaapp.vercel.app/auth/profile",
  //     options: Options(
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     ),
  //   );
  //
  //   return UserModel.fromJson(response.data);
  // }
}