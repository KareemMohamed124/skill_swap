import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/shared/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../bloc/activation_bloc/activation_bloc.dart';
import '../bloc/book_session/book_session_bloc.dart';
import '../bloc/cancel_book_bloc/cancel_book_bloc.dart';
import '../bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../bloc/delete_account_bloc/delete_account_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/report_bloc/report_bloc.dart';
import '../bloc/reset_password_bloc/reset_password_bloc.dart';
import '../bloc/send_code_bloc/send_code_bloc.dart';
import '../bloc/status_book_bloc/status_book_bloc.dart';
import '../bloc/track_cubit/track_cubit.dart';
import '../bloc/update_book_bloc/update_book_bloc.dart';
import '../bloc/update_profile_bloc/update_profile_bloc.dart';
import '../bloc/user_filter_bloc/user_filter_bloc.dart';
import '../bloc/verify_code_bloc/verify_code_bloc.dart';
import '../constants/strings.dart';
import '../core/network/auth_interceptor.dart';
import '../data/models/user/user_model.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/repositories/report_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/web_services/auth/auth_api.dart';
import '../data/web_services/booking/booking_api.dart';
import '../data/web_services/report/report_api.dart';
import '../data/web_services/user/user_api.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/report_repository.dart';
import '../domain/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  // Auth Interceptor — handles token attachment + auto-refresh
  dio.interceptors.add(AuthInterceptor(dio));

  // APIs
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<Dio>()));
  sl.registerLazySingleton<BookingApi>(() => BookingApi(sl<Dio>()));
  sl.registerLazySingleton<UserApi>(() => UserApi(sl<Dio>()));
  sl.registerLazySingleton<ReportApi>(() => ReportApi(sl<Dio>()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(api: sl<AuthApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(api: sl<BookingApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(api: sl<UserApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<ReportRepository>(
      () => ReportRepositoryImpl(api: sl<ReportApi>(), dio: sl<Dio>()));

  // Blocs
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl<AuthRepository>()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthRepository>()));
  sl.registerFactory<SendCodeBloc>(() => SendCodeBloc(sl<AuthRepository>()));
  sl.registerFactory<VerifyCodeBloc>(
      () => VerifyCodeBloc(sl<AuthRepository>()));
  sl.registerFactory<ResetPasswordBloc>(
      () => ResetPasswordBloc(sl<AuthRepository>()));
  sl.registerFactory<BookSessionBloc>(
      () => BookSessionBloc(sl<BookingRepository>()));
  sl.registerFactory<StatusBookBloc>(
      () => StatusBookBloc(sl<BookingRepository>()));
  sl.registerFactory<CancelBookBloc>(
      () => CancelBookBloc(sl<BookingRepository>()));
  sl.registerFactory<UpdateBookBloc>(
      () => UpdateBookBloc(sl<BookingRepository>()));
  sl.registerFactory<UsersCubit>(() => UsersCubit(sl<UserRepository>()));
  sl.registerFactory<ChangePasswordBloc>(
      () => ChangePasswordBloc(sl<UserRepository>()));
  sl.registerFactory<UpdateProfileBloc>(
      () => UpdateProfileBloc(sl<UserRepository>()));
  sl.registerFactory<ReportBloc>(() => ReportBloc(sl<ReportRepository>()));
  sl.registerLazySingleton<MyProfileCubit>(
    () => MyProfileCubit(sl<UserRepository>()),
  );
  sl.registerFactory<LogoutBloc>(() => LogoutBloc(sl<AuthRepository>()));
  sl.registerFactory<DeleteAccountBloc>(
      () => DeleteAccountBloc(sl<UserRepository>()));
  sl.registerFactory<ActivationBloc>(
      () => ActivationBloc(sl<AuthRepository>()));

  sl.registerFactory<CompleteProfileBloc>(
      () => CompleteProfileBloc(sl<AuthRepository>()));

  sl.registerFactory<TracksCubit>(() => TracksCubit(sl<AuthRepository>()));
  sl.registerFactory<MentorFilterBloc>(() => MentorFilterBloc(AppData.mentors));

  // Load users safely
  List<UserModel> users = [];
  try {
    users = await sl<UserRepository>().getAllUsers();
  } catch (e) {
    print("Failed to fetch users, using empty list: $e");
  }

  sl.registerFactory<UserFilterBloc>(() =>
      UserFilterBloc(userRepository: sl<UserRepository>(), allUsers: users));
}
