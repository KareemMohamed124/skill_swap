import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/sign/screens/sign_in_screen.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';
import 'package:skill_swap/shared/helper/local_storage.dart';

import '../../domain/repositories/user_repository.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepository repository;

  num get coins {
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

      emit(MyProfileLoaded(myProfile));
    } catch (e) {
      final message = e.toString();

      emit(MyProfileError(message));

      if (message.toLowerCase().contains("blocked")) {
        await LocalStorage.clearAllTokens();

        Get.dialog(
          AlertDialog(
            title: const Text("Account Blocked"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Get.offAll(() => const SignInScreen());
                },
                child: const Text("OK"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
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

  Future<void> setActiveTheme(String? themeId) async {
    try {
      await repository.setActiveTheme(themeId);
      await refreshProfile();
    } catch (e) {}
  }

  void setProfile(MyProfile profile) {
    if (!isClosed) emit(MyProfileLoaded(profile));
  }

  void clearProfile() {
    if (!isClosed) emit(MyProfileInitial());
  }
}
