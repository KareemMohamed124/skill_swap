import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

import '../../domain/repositories/user_repository.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepository repository;

  int get coins {
    final state = this.state;
    if (state is MyProfileLoaded) {
      return state.profile.points ?? 0;
    }
    return 0;
  }

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

  bool canAddSkill(String skillName) {
    final currentState = state;

    if (currentState is MyProfileLoaded) {
      final profile = currentState.profile;

      final isMentor = profile.role == "Mentor";

      if (!isMentor) return false;

      final skills = profile.skills ?? [];

      final exists = skills.any(
        (skill) => skill.skillName.toLowerCase() == skillName.toLowerCase(),
      );

      return !exists;
    }

    return false;
  }

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

  Future<void> setActiveTheme(String themeId) async {
    try {
      await repository.setActiveTheme(themeId); // API call
      await refreshProfile(); // refresh profile
    } catch (e) {
      // handle error
    }
  }

  void setProfile(MyProfile profile) {
    if (!isClosed) emit(MyProfileLoaded(profile));
  }

  void clearProfile() {
    if (!isClosed) emit(MyProfileInitial());
  }
}
