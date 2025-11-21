import 'package:skill_swap/data/models/register_error_response.dart';
import 'package:skill_swap/data/models/register_success_response.dart';

sealed class RegisterResponse {}

class RegisterSuccess extends RegisterResponse {
  final RegisterSuccessResponse data;

  RegisterSuccess(this.data);
}

class RegisterFailure extends RegisterResponse {
  final RegisterErrorResponse error;

  RegisterFailure(this.error);
}
