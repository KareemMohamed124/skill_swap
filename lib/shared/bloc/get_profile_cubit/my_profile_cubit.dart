import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

import '../../domain/repositories/user_repository.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepository repository;

  MyProfileCubit(this.repository) : super(MyProfileInitial());

  void fetchMyProfile() async {
    if (isClosed) return;
    emit(MyProfileLoading());

    try {
      final myProfile = await repository.getMyProfile();
      if (isClosed) return;
      emit(MyProfileLoaded(myProfile));
    } catch (e) {
      if (isClosed) return;
      emit(MyProfileError(e.toString()));
    }
  }

  /// ✅ FIXED REFRESH
  Future<void> refreshProfile() async {
    if (isClosed) return;

    emit(MyProfileLoading());

    try {
      final myProfile = await repository.getMyProfile();
      if (isClosed) return;

      emit(MyProfileLoaded(myProfile));
    } catch (e) {
      if (isClosed) return;
      emit(MyProfileError(e.toString()));
    }
  }

  void setProfile(MyProfile profile) {
    if (!isClosed) emit(MyProfileLoaded(profile));
  }

  void clearProfile() {
    if (!isClosed) emit(MyProfileInitial());
  }
}
