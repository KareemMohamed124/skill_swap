import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

import '../../domain/repositories/user_repository.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepository repository;

  MyProfileCubit(this.repository) : super(MyProfileInitial());

  void fetchMyProfile() async {
    emit(MyProfileLoading());

    try {
      final myProfile = await repository.getMyProfile();
      emit(MyProfileLoaded(myProfile));
    } catch (e) {
      emit(MyProfileError(e.toString()));
    }
  }

  void setProfile(MyProfile profile) {
    emit(MyProfileLoaded(profile));
  }

  /// Clears the current profile state and resets to initial.
  /// Call this during logout to avoid old data persisting.
  void clearProfile() {
    emit(MyProfileInitial());
  }

  /// Refreshes the profile by clearing first then fetching new data.
  /// Optional: Use this after login if you want a clean refresh.
  void refreshProfile() async {
    clearProfile(); // Clean first
    fetchMyProfile(); // Then fetch new
  }
}
