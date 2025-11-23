import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:skill_swap/data/models/login/login_request.dart';
import 'package:skill_swap/data/models/login/login_success_response_new.dart';
import '../models/register_request.dart';
import '../models/register_success_response.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/api/auth/")
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("register/")
  Future<RegisterSuccessResponse> register(@Body() RegisterRequest body);

  @POST("login/")
  Future<LoginSuccessResponseNew> login(@Body() LoginRequest body);
}
