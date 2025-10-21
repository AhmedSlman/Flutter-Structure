import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/{{featureName.snakeCase()}}_repository.dart';
import '../data/models/request/{{featureName.snakeCase()}}_request.dart';
import '../data/models/response/{{featureName.snakeCase()}}_model.dart';
import '../../../../../core/error/result_extensions.dart';
import '{{featureName.snakeCase()}}_states.dart';

class {{featureName.pascalCase()}}Cubit extends Cubit<{{featureName.pascalCase()}}States> {
  final {{featureName.pascalCase()}}Repository repository;
  {{featureName.pascalCase()}}Cubit(this.repository) : super({{featureName.pascalCase()}}Initial());
  static {{featureName.pascalCase()}}Cubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const {{featureName.pascalCase()}}Request());
    
    result.fold(
      (failure) => emit({{featureName.pascalCase()}}Error(failure.message)),
      (items) => emit({{featureName.pascalCase()}}Success(items)),
    );
  }

}


