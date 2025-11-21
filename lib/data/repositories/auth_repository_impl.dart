import 'package:dio/dio.dart';
import '../../data/models/register_request.dart';
import '../../data/models/register_error_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/register_response.dart';
import '../web_services/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  final Dio dio;

  AuthRepositoryImpl({required this.api, required this.dio});

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await api.register(request);

      if (response.message == "User Registered Successfully") {
        return RegisterSuccess(response);
      }
      return RegisterFailure(RegisterErrorResponse(message: response.message));
    } on DioException catch (e) {
      return RegisterFailure(
        RegisterErrorResponse(message: e.message ?? "Network Error"),
      );
    } catch (e) {
      return RegisterFailure(RegisterErrorResponse(message: e.toString()));
    }
  }
}
