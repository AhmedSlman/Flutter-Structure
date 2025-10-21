import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/{{featureName.snakeCase()}}_request.dart';
import '../../models/response/{{featureName.snakeCase()}}_model.dart';
import '../../repository/endpoints.dart';

abstract class {{featureName.pascalCase()}}RemoteDataSource {
  Future<Result<List<{{featureName.pascalCase()}}Model>>> fetchItems({{featureName.pascalCase()}}Request request);

}

class {{featureName.pascalCase()}}RemoteDataSourceImpl implements {{featureName.pascalCase()}}RemoteDataSource {
  final ApiConsumer _apiConsumer;
  {{featureName.pascalCase()}}RemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<{{featureName.pascalCase()}}Model>>> fetchItems({{featureName.pascalCase()}}Request request) async {
    final result = await _apiConsumer.get<List<{{featureName.pascalCase()}}Model>>(
      path: {{featureName.pascalCase()}}Endpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => {{featureName.pascalCase()}}Model.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  };

 
}


