import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../bloc/delete_account_bloc/delete_account_bloc.dart';
import '../bloc/activation_bloc/activation_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/reset_password_bloc/reset_password_bloc.dart';
import '../bloc/send_code_bloc/send_code_bloc.dart';
import '../bloc/tracks_cubit/tracks_cubit.dart';
import '../bloc/verify_code_bloc/verify_code_bloc.dart';
import '../constants/strings.dart';
import '../core/network/auth_interceptor.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/web_services/auth_api.dart';
import '../domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Dio
  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  // Auth Interceptor — handles token attachment + auto-refresh
  dio.interceptors.add(AuthInterceptor(dio));

  // API
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<Dio>()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(api: sl<AuthApi>(), dio: sl<Dio>()),
  );

  // Bloc
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl<AuthRepository>()));

  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthRepository>()));

  sl.registerFactory<SendCodeBloc>(() => SendCodeBloc(sl<AuthRepository>()));

  sl.registerFactory<VerifyCodeBloc>(
      () => VerifyCodeBloc(sl<AuthRepository>()));

  sl.registerFactory<ResetPasswordBloc>(
      () => ResetPasswordBloc(sl<AuthRepository>()));

  sl.registerFactory<DeleteAccountBloc>(
      () => DeleteAccountBloc(sl<AuthRepository>()));

  sl.registerFactory<MentorFilterBloc>(() => MentorFilterBloc(AppData.mentors));

  sl.registerFactory<ActivationBloc>(
      () => ActivationBloc(sl<AuthRepository>()));

  sl.registerFactory<CompleteProfileBloc>(
      () => CompleteProfileBloc(sl<AuthRepository>()));

  sl.registerFactory<TracksCubit>(() => TracksCubit(sl<AuthRepository>()));
}
