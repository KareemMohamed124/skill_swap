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
  Future<UsersResponse> getAllUsers(
      @Query("page") int page, @Query("limit") int limit);

  @GET("user/profile")
  Future<ProfileResponse> getMyProfile();

  @GET("user/all-users")
  Future<UsersResponse> searchUsers(
      {@Query("search") String? query,
      @Query("page") int page,
      @Query("limit") int limit});

  @GET("user/all-users")
  Future<UsersResponse> sortUsers(
      {@Query("sort") String? query,
      @Query("page") int page,
      @Query("limit") int limit});

  @GET("user/all-users")
  Future<UsersResponse> filterUsers(
      {@Query("role") String? role,
      @Query("track") String? track,
      @Query("minRating") int? minRating,
      @Query("minPrice") int? minPrice,
      @Query("maxPrice") int? maxPrice,
      @Query("page") int page,
      @Query("limit") int limit});

  @PATCH("user/profile")
  Future<dynamic> updateProfile(
<<<<<<< HEAD
    @Body() Map<String, dynamic> body,
=======
    @Body() UpdateProfileRequest body,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD

  @POST("user/request-mentor")
  Future<dynamic> requestMentor(@Body() Map<String, dynamic> body);

  @PATCH("user/select-theme")
  Future<dynamic> setActiveTheme(
    @Body() Map<String, dynamic> body,
  );
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
