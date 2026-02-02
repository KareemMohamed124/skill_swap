import '../../data/models/login/login_request.dart';
import '../../data/models/login/login_response.dart';
import '../../data/models/register/register_request.dart';
import '../../data/models/register/register_response.dart';
import '../../data/models/reset_password/reset_password_request.dart';
import '../../data/models/reset_password/reset_password_response.dart';
import '../../data/models/send_code/send_code_request.dart';
import '../../data/models/send_code/send_code_response.dart';
import '../../data/models/user/user_model.dart';
import '../../data/models/verify_code/verify_code_request.dart';
import '../../data/models/verify_code/verify_code_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<SendCodeResponse> sendCode(SendCodeRequest request);
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request);
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);
  Future<UserModel> getProfile();
}
