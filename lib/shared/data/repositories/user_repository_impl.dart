import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart' as p;
import 'package:skill_swap/shared/data/models/change_password/change_password_request.dart';
import 'package:skill_swap/shared/data/models/change_password/change_password_response.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

import '../../domain/repositories/user_repository.dart';
import '../../helper/local_storage.dart';
import '../models/change_password/change_password_error_response.dart';
import '../models/delete_account/delete_account_response.dart';
import '../models/update_profile/update_profile_request.dart';
import '../models/update_profile/update_profile_response.dart';
import '../models/user/user_model.dart';
import '../web_services/user/user_api.dart';

class UserRepositoryImpl extends UserRepository {
  final Dio dio;
  final UserApi api;

  UserRepositoryImpl({required this.dio, required this.api});

  Future<List<UserModel>> _excludeMyAccountAndAdmin(
      List<UserModel> users) async {
    final token = await LocalStorage.getToken();
    String? myId;

    if (token != null && !JwtDecoder.isExpired(token)) {
      final decoded = JwtDecoder.decode(token);
      myId = decoded['_id'];
    }

    return users.where((user) {
      final isMe = user.id == myId;
      final isAdmin = user.role?.toLowerCase() == "admin";
      return !isMe && !isAdmin;
    }).toList();
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await api.getAllUsers();
    return _excludeMyAccountAndAdmin(response.data.users);
  }

  @override
  Future<MyProfile> getMyProfile() async {
    final response = await api.getMyProfile();
    return response.user;
  }

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<List<UserModel>> searchUsers({String? query}) async {
    List<UserModel> users;
    if (query == null || query.isEmpty) {
      users = await api.getAllUsers().then((res) => res.data.users);
    } else {
      users = await api.searchUsers(query: query).then((res) => res.data.users);
    }
    return _excludeMyAccountAndAdmin(users);
  }

  @override
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest request) async {
    try {
      final response = await api.changePassword(request);
      if (response.message == 'Password changed successfully') {
        return ChangePasswordSuccess(response);
      }
      return ChangePasswordFailure(
        ChangePasswordErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = ChangePasswordErrorResponse.fromJson(e.response!.data);
        return ChangePasswordFailure(error);
      }
      return ChangePasswordFailure(
        ChangePasswordErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return ChangePasswordFailure(
        ChangePasswordErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<UpdateProfileResponse> updateProfile(
      UpdateProfileRequest request) async {
    try {
      final response = await api.updateProfile(request);
      return UpdateProfileData.fromJson(response);
    } on DioException catch (e) {
      String serverMessage = "Network Error";
      if (e.response?.data != null) {
        try {
          final data = e.response!.data;
          if (data is Map && data['message'] != null) {
            serverMessage = data['message'].toString();
          } else if (data is String) {
            serverMessage = data;
          }
        } catch (_) {}
      }
      return UpdateProfileFailure(error: serverMessage);
    } catch (e) {
      return UpdateProfileFailure(error: e.toString());
    }
  }

  @override
  Future<DeleteAccountResponse> deleteAccount() async {
    try {
      await api.deleteAccount();
      await LocalStorage.clearAllTokens();
      return DeleteAccountSuccess();
    } on DioException catch (e) {
      return DeleteAccountFailure(_getServerErrorMessage(e));
    } catch (e) {
      return DeleteAccountFailure(e.toString());
    }
  }

  @override
  Future<List<UserModel>> filterUsers({
    String? role,
    String? track,
    int? minRating,
    int? minPrice,
    int? maxPrice,
  }) async {
    final response = await api.filterUsers(
      role: role,
      track: track,
      minRating: minRating,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    return _excludeMyAccountAndAdmin(response.data.users);
  }

  @override
  Future<List<UserModel>> sortUsers({String? query}) async {
    List<UserModel> users;
    if (query == null || query.isEmpty) {
      users = await api.getAllUsers().then((res) => res.data.users);
    } else {
      users = await api.sortUsers(query: query).then((res) => res.data.users);
    }
    return _excludeMyAccountAndAdmin(users);
  }

  @override
  Future<UpdateProfileResponse> updateProfileImage(String imagePath) async {
    try {
      final file = await MultipartFile.fromFile(
        imagePath,
        filename: p.basename(imagePath),
      );

      final response = await api.updateProfileImage(file);
      return UpdateProfileData.fromJson(response);
    } on DioException catch (e) {
      String serverMessage = _getServerErrorMessage(e);
      return UpdateProfileFailure(error: serverMessage);
    } catch (e) {
      return UpdateProfileFailure(error: e.toString());
    }
  }
}
