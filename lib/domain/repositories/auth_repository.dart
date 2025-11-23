import 'dart:io';


import 'package:skill_swap/data/models/register/register_response.dart';
import '../../data/models/register/register_request.dart';
import '../../data/models/reset_password/reset_password_request.dart';
import '../../data/models/reset_password/reset_password_response.dart';
import '../../data/models/reset_password/reset_password_success_response.dart';
import '../../data/models/send_code/send_code_request.dart';
import '../../data/models/send_code/send_code_response.dart';
import '../../data/models/verify_code/verify_code_request.dart';
import '../../data/models/verify_code/verify_code_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<SendCodeResponse> sendCode(SendCodeRequest request);
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request);
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);

}
