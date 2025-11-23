import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/data/repositories/auth_repository_impl.dart';
import 'package:skill_swap/domain/repositories/auth_repository.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../data/web_services/auth_api.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<Dio>()));

  // Register Repository as general interface
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(api: sl<AuthApi>(), dio: sl<Dio>()),
  );

  // Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthRepository>()));
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl<AuthRepository>()));
}
