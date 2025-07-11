import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../core/env/env.dart';
import '../core/network/dio_factory.dart';
import '../notifications/notification_service.dart';
import '../notifications/notification_navigation_service.dart';
import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/notification/notification_repository.dart';
import '../data/repositories/notification/notification_repository_impl.dart';
import '../data/repositories/product/product_repository.dart';
import '../data/repositories/product/product_repository_impl.dart';
import '../data/services/auth_api_service.dart';
import '../data/services/notification_api_service.dart';
import '../data/services/product_api_service.dart';
import '../domain/usecase/forgot_password_usecase.dart';
import '../domain/usecase/get_products_usecase.dart';
import '../domain/usecase/login_usecase.dart';
import '../domain/usecase/register_usecase.dart';
import '../domain/usecase/update_fcm_token_usecase.dart';
import '../presentation/viewmodels/auth_view_model.dart';
import '../presentation/viewmodels/product_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies(GoRouter router) {
  // Register for Services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  getIt.registerLazySingleton<NotificationNavigationService>(
    () => NotificationNavigationService()..setRouter(router),
  );
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(DioFactory.createDio(Env.baseUrlAuth, router: router)),
  );
  getIt.registerLazySingleton<ProductApiService>(
    () => ProductApiService(DioFactory.createDio(Env.baseUrlProduct, router: router)),
  );
  getIt.registerLazySingleton<NotificationApiService>(
    () => NotificationApiService(DioFactory.createDio(Env.baseUrlAuth, router: router)),
  );
  //-----

  // Register for Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );
//-----

  // Register for ViewModels
  getIt.registerFactory(
    () => AuthViewModel(
      LoginUseCase(getIt()),
      RegisterUseCase(getIt()),
      ForgotPasswordUseCase(getIt()),
    ),
  );
  getIt.registerFactory(() => ProductViewModel(GetProductsUseCase(getIt())));
  //-----

  // Register for useCase
  getIt.registerFactory(() => UpdateFCMTokenUseCase(getIt()));
  //----
}
