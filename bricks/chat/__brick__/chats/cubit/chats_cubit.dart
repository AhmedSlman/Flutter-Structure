import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/utils/Locator.dart';
import '../domain/model/chats_model.dart';
import '../domain/repository/repository.dart';
import 'chats_states.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitial());
  static ChatsCubit get(context) => BlocProvider.of(context);

  ChatsRepository chatsRepository = locator<ChatsRepository>();
  PagingController<int, ChatModel> chatPagingcontroller =
      PagingController<int, ChatModel>(firstPageKey: 1);

  addpageListener() {
    chatPagingcontroller.addPageRequestListener((pageKey) {
      getChats(page: pageKey);
    });
  }

  getChats({int? page}) async {
    emit(GetChatsLoadingState());
    final response = await chatsRepository.getChats(page);
    if (response != null) {
      if (response.lastPage == page) {
        chatPagingcontroller.appendLastPage(response.chats ?? []);
      } else {
        var nextPageKey = page! + 1;
        chatPagingcontroller.appendPage(response.chats ?? [], nextPageKey);
      }
      emit(GetChatsSuccessState());
    } else {
      emit(GetChatsErrorState());
    }
  }
}
