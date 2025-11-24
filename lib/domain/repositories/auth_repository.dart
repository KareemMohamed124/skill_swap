import 'package:skill_swap/data/models/register_response.dart';
import '../../data/models/register_request.dart';
import '../../data/models/login/login_request.dart';
import '../../data/models/login/login_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
}
