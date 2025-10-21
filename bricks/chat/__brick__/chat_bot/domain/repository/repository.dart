import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => ChatBotRepository(locator<DioService>()));
//  import '../../modules/chat_bot/domain/repository/repository.dart';
class ChatBotRepository {
  final DioService dioService;
  ChatBotRepository(this.dioService);
}
