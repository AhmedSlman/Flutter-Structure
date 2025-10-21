import '../../../../core/data_source/dio_helper.dart';
import '../request/static_page_request.dart';

class StaticPageRepository {
  final DioService dioService;
  StaticPageRepository(this.dioService);
  contactUs({required ContactUsRequest contactUsRequest}) async {
    final body = await contactUsRequest.toJson();
    final respose = await dioService.postData(
        url: "/contact-us", isForm: true, loading: true, body: body);
    if (respose.isError == false) {
      return respose.response?.data;
    }
  }

  //////////////
  aboutUs() async {
    final respose = await dioService.getData(url: "/about-us", loading: false);
    if (respose.isError == false) {
      return respose.response?.data;
    }
  }
}
