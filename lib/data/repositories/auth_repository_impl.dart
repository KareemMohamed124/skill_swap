import 'package:dio/dio.dart';
import 'package:skill_swap/data/models/verify_code/verify_code_request.dart';
import 'package:skill_swap/data/models/verify_code/verify_code_response.dart';
import '../models/register/register_request.dart';
import '../models/register/register_error_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/register/register_response.dart';
import '../models/send_code/send_code_error_response.dart';
import '../models/send_code/send_code_request.dart';
import '../models/send_code/send_code_response.dart';
import '../models/verify_code/verify_code_error_response.dart';
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

  @override
  Future<SendCodeResponse> sendCode(SendCodeRequest request) async{
   try{
     final response = await api.sendCode(request);

     if(response.message == "Resend Verification Code") {
       return SendCodeSuccess(response);
     }
     return SendCodeFailure(SendCodeErrorResponse(message: response.message));
   }
   on DioException catch (e){
     return SendCodeFailure(SendCodeErrorResponse(message: e.message ?? "Network Error"));
   }
    catch(e){
     return  SendCodeFailure(SendCodeErrorResponse(message: e.toString()));
    }
  }


  @override
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request) async{
    try{
      final response = await api.verifyCode(request);

      if(response.message == "Resend Verification Code") {
        return VerifyCodeSuccess(response);
      }
      return VerifyCodeFailure(VerifyCodeErrorResponse(message: response.message));
    }
    on DioException catch (e){
      return VerifyCodeFailure(VerifyCodeErrorResponse(message: e.message ?? "Network Error"));
    }
    catch(e){
      return  VerifyCodeFailure(VerifyCodeErrorResponse(message: e.toString()));
    }
  }

}
