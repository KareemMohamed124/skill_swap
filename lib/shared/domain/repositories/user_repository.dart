import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';
import 'package:skill_swap/shared/data/models/user/user_model.dart';

import '../../data/models/change_password/change_password_request.dart';
import '../../data/models/change_password/change_password_response.dart';
import '../../data/models/delete_account/delete_account_response.dart';
import '../../data/models/update_profile/update_profile_request.dart';
import '../../data/models/update_profile/update_profile_response.dart';

abstract class UserRepository {
  Future<List<UserModel>> getAllUsers();

  Future<MyProfile> getMyProfile();

  Future<List<UserModel>> searchUsers({String? query});

  Future<List<UserModel>> sortUsers({String? query});

  Future<List<UserModel>> filterUsers(
      {String? role,
      String? track,
      int? minRating,
      int? minPrice,
      int? maxPrice});

  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);

  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);

  Future<UpdateProfileResponse> updateProfileImage(String imagePath);

  Future<DeleteAccountResponse> deleteAccount();
}
