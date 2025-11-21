import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../models/register/register_request.dart';
import '../models/register/register_success_response.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/api/auth/")
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("register/")
  Future<RegisterSuccessResponse> register(@Body() RegisterRequest body);
}
