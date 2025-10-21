import '../../../../core/data_source/dio_helper.dart';
import '../model/chats_model.dart';

//put it in locators locator.registerLazySingleton(() => ChatsRepository(locator<DioService>()));
//  import '../../modules/chats/domain/repository/repository.dart';
class ChatsRepository {
  final DioService dioService;
  ChatsRepository(this.dioService);

  Future<PagedChatsModel?> getChats(int? page) async {
    final ApiResponse response = await dioService.getData(
      url: "chats/my-chats",
      query: {"page": page},
    );
    if (response.isError == false) {
      return PagedChatsModel.fromMap(response.response?.data);
    } else {
      return null;
    }
  }
}
