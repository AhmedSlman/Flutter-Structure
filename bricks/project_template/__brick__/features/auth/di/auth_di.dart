import '../data/data_source/local/auth_local_data_source.dart';
import '../data/data_source/remote/auth_remote_data_source.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/auth_repository_impl.dart';
import '../logic/auth_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for Auth feature
class AuthDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
      ),
    );

    // Cubit
    sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
  }

  /// Clean up dependencies (useful for testing)
  static void cleanup() {
    if (sl.isRegistered<AuthCubit>()) {
      sl.unregister<AuthCubit>();
    }
    if (sl.isRegistered<AuthRepository>()) {
      sl.unregister<AuthRepository>();
    }
    if (sl.isRegistered<AuthRemoteDataSource>()) {
      sl.unregister<AuthRemoteDataSource>();
    }
    if (sl.isRegistered<AuthLocalDataSource>()) {
      sl.unregister<AuthLocalDataSource>();
    }
  }
}
