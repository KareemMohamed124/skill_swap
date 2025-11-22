import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/bloc/verify_code_bloc/verify_code_bloc.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/send_code_bloc/send_code_bloc.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/web_services/auth_api.dart';
import '../domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Dio
  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  // API
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<Dio>()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(api: sl<AuthApi>(), dio: sl<Dio>()),
  );

  // Bloc
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl<AuthRepository>()));

  sl.registerFactory<SendCodeBloc>(() => SendCodeBloc(sl<AuthRepository>()));

  sl.registerFactory<VerifyCodeBloc>(() => VerifyCodeBloc(sl<AuthRepository>()));
}
