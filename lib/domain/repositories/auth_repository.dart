import 'dart:io';

import 'package:skill_swap/data/models/register_response.dart';
import '../../data/models/register_request.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);
}
