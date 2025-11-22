import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../models/register/register_request.dart';
import '../models/register/register_success_response.dart';
import '../models/send_code/send_code_request.dart';
import '../models/send_code/send_code_success_response.dart';
import '../models/verify_code/verify_code_request.dart';
import '../models/verify_code/verify_code_success_response.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/api/auth/")
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("register/")
  Future<RegisterSuccessResponse> register(@Body() RegisterRequest body);
  @PATCH("sendCode/")
  Future<SendCodeSuccessResponse> sendCode(@Body() SendCodeRequest body);
  @PATCH("forgetPassword/")
  Future<VerifyCodeSuccessResponse> verifyCode(@Body() VerifyCodeRequest body);

}
