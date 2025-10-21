import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data_source/dio_helper.dart';
import '../domain/request/static_page_request.dart';
import '../domain/repository/repository.dart';
import '../../../core/utils/Locator.dart';
import 'states.dart';

class StaticPageCubit extends Cubit<StaticPageStates> {
  StaticPageCubit() : super(StaticPageInitial());
  static StaticPageCubit get(context) => BlocProvider.of(context);

  StaticPageRepository staticPageRepository =
      StaticPageRepository(locator<DioService>());

  //contact us
  contactUs({required ContactUsRequest contactUsRequest}) async {
    final respose = await staticPageRepository.contactUs(
        contactUsRequest: contactUsRequest);
    if (respose != null) {
      emit(ContactUsSendSuccess(
        message: respose["message"],
      ));
    } else {}
  }

  // about us
  aboutUs() async {
    final respose = await staticPageRepository.aboutUs();
    if (respose != null) {
      return respose;
    } else {}
  }

  @override
  void emit(StaticPageStates state) {
    if (isClosed) return;

    super.emit(state);
  }
}
