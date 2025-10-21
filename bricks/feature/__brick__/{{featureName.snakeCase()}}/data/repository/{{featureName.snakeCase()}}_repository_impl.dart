import '{{featureName.snakeCase()}}_repository.dart';
import '../data_source/local/local_data_source.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/{{featureName.snakeCase()}}_request.dart';
import '../models/response/{{featureName.snakeCase()}}_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';

class {{featureName.pascalCase()}}RepositoryImpl implements {{featureName.pascalCase()}}Repository {
  final {{featureName.pascalCase()}}RemoteDataSource remoteDataSource;

  {{featureName.pascalCase()}}RepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Result<List<{{featureName.pascalCase()}}Model>>> fetchItems({{featureName.pascalCase()}}Request request) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  };

 
}


