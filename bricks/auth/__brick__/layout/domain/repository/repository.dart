import 'endpoints.dart';

import '../model/layout_model.dart';
import '../../../../core/data_source/dio_helper.dart';

  //put it in locators locator.registerLazySingleton(() => LayoutRepository(locator<DioService>()));
//  import '../../modules/layout/domain/repository/repository.dart';
class LayoutRepository{
final  DioService dioService ;
  LayoutRepository(this.dioService);
}
