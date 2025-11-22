import 'package:skill_swap/data/models/register/register_error_response.dart';
import 'package:skill_swap/data/models/register/register_success_response.dart';
import 'package:skill_swap/data/models/send_code/sendcode_error_response.dart';
import 'package:skill_swap/data/models/send_code/sendcode_success_response.dart';


sealed class SendCodeResponse {}

class SendCodeSuccess extends SendCodeResponse {
  final SendCodeSuccessResponse data;
    SendCodeSuccess(this.data);
}

class SendCodeFailure extends SendCodeResponse {
  final SendCodeErrorResponse error;

  SendCodeFailure(this.error);
}
