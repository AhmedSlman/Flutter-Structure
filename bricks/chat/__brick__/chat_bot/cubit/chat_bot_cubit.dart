import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'chat_bot_states.dart';

class ChatBotCubit extends Cubit<ChatBotStates> {
  ChatBotCubit() : super(ChatBotInitial());
  static ChatBotCubit get(context) => BlocProvider.of(context);

  ChatBotRepository chatBotRepository = locator<ChatBotRepository>();
  final pagingController = PagingController<dynamic, Object?>(firstPageKey: 1);
}
