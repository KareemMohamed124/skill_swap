import 'dart:io';


import 'package:skill_swap/data/models/register/register_response.dart';
import '../../data/models/register/register_request.dart';
import '../../data/models/send_code/send_code_request.dart';
import '../../data/models/send_code/send_code_response.dart';
import '../../data/models/verify_code/verify_code_request.dart';
import '../../data/models/verify_code/verify_code_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<SendCodeResponse> sendCode(SendCodeRequest request);
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request);
}
