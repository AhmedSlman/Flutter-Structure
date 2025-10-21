import '../models/request/{{featureName.snakeCase()}}_request.dart';
import '../models/response/{{featureName.snakeCase()}}_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class {{featureName.pascalCase()}}Repository {
  Future<Result<List<{{featureName.pascalCase()}}Model>>> fetchItems({{featureName.pascalCase()}}Request request);
}


