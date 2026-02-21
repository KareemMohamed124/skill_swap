import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:skill_swap/shared/data/models/my_profile/profile_response.dart';

import '../../models/change_password/change_password_request.dart';
import '../../models/change_password/change_password_success_response.dart';
import '../../models/update_profile/update_profile_request.dart';
import '../../models/user/user_response.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/")
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("user/all-users")
  Future<UsersResponse> getAllUsers();

  @GET("user/profile")
  Future<ProfileResponse> getMyProfile();

  @GET("user/all-users")
  Future<UsersResponse> searchUsers({@Query("search") String? query});

  @GET("user/all-users")
  Future<UsersResponse> sortUsers({@Query("sort") String? query});

  @GET("user/all-users")
  Future<UsersResponse> filterUsers(
      {@Query("role") String? role,
      @Query("track") String? track,
      @Query("minRating") int? minRating,
      @Query("minPrice") int? minPrice,
      @Query("maxPrice") int? maxPrice});

  @PATCH("user/profile")
  Future<Map<String, dynamic>> updateProfile(
    @Body() UpdateProfileRequest body,
  );

  @PATCH("user/profile")
  @MultiPart()
  Future<Map<String, dynamic>> updateProfileImage(
      @Part(name: "userImage") MultipartFile image);

  @PATCH("user/change-password")
  Future<ChangePasswordSuccessResponse> changePassword(
    @Body() ChangePasswordRequest body,
  );

  @DELETE("user/delete")
  Future<void> deleteAccount();
}
