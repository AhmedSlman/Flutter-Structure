import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/{{featureName.snakeCase()}}_repository.dart';
import '../data/repository/{{featureName.snakeCase()}}_repository_impl.dart';
import '../logic/{{featureName.snakeCase()}}_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for {{featureName.pascalCase()}} feature
class {{featureName.pascalCase()}}DI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<{{featureName.pascalCase()}}RemoteDataSource>(
      () => {{featureName.pascalCase()}}RemoteDataSourceImpl(
        sl<ApiConsumer>(),
      ),
    );

    sl.registerLazySingleton<{{featureName.pascalCase()}}LocalDataSource>(
      () => {{featureName.pascalCase()}}LocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<{{featureName.pascalCase()}}Repository>(
      () => {{featureName.pascalCase()}}RepositoryImpl(
        remoteDataSource: sl<{{featureName.pascalCase()}}RemoteDataSource>(),
        localDataSource: sl<{{featureName.pascalCase()}}LocalDataSource>(),
      ),
    );

    // Cubit
    sl.registerFactory<{{featureName.pascalCase()}}Cubit>(
      () => {{featureName.pascalCase()}}Cubit(
        sl<{{featureName.pascalCase()}}Repository>(),
      ),
    );
  }


}
