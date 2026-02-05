import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/reset_password_bloc/reset_password_bloc.dart';
import '../bloc/send_code_bloc/send_code_bloc.dart';
import '../bloc/verify_code_bloc/verify_code_bloc.dart';
import '../constants/strings.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/web_services/auth_api.dart';
import '../domain/repositories/auth_repository.dart';
import '../helper/local_storage.dart';

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

  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthRepository>()));

  sl.registerFactory<SendCodeBloc>(() => SendCodeBloc(sl<AuthRepository>()));

  sl.registerFactory<VerifyCodeBloc>(() => VerifyCodeBloc(sl<AuthRepository>()));

  sl.registerFactory<ResetPasswordBloc>(() => ResetPasswordBloc(sl<AuthRepository>()));

  sl.registerLazySingleton<MentorFilterBloc>(() => MentorFilterBloc(AppData.mentors));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorage.getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await LocalStorage.clearToken();
          Get.offAll(const SignInScreen());
        }
        return handler.next(e);
      },
    ),
  );

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() => Dio());
  }
}
