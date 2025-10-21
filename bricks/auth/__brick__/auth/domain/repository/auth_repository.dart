import '../../../../core/data_source/dio_helper.dart';
import '../../../../core/services/alerts.dart';
import '../request/auth_request.dart';
import 'end_points.dart';

class AuthRepository {
  final DioService dioService;
  AuthRepository(this.dioService);

  loginRequest(AuthRequest user) async {
    final response = await dioService.postData(
        url: AuthEndPoints.login, body: user.login(), loading: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  registerRequest(AuthRequest user) async {
    final response = await dioService.postData(
        url: AuthEndPoints.register, body: user.register(), loading: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  resendCodeRequest(String email) async {
    final response = await dioService.postData(
        url: AuthEndPoints.resendCode, body: {'email': email}, isForm: true);
    if (response.isError == false) {
      // Alerts.snack(text: response.response?.data['message'], state: 1);
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  sendCodeRequest({required String email, required String code}) async {
    final response = await dioService.postData(
        url: AuthEndPoints.sendCode,
        body: {'email': email, 'code': code},
        loading: true,
        isForm: true);
    if (response.isError == false) {
      // Alerts.snack(text: response.response?.data['message'], state: 1);
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  forgetPassRequest(String email) async {
    final response = await dioService.postData(
      url: AuthEndPoints.forgetPassword,
      body: {'email': email},
      isForm: true,
      loading: true,
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.success);
      return response.response?.data['data'];
    } else {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.failed);
      return null;
    }
  }

  resetPassword({
    required String code,
    required String pass,
    required String email,
  }) async {
    final response = await dioService.postData(
      url: AuthEndPoints.resetPassword,
      body: {
        'code_id': code,
        'password': pass,
        'email': email,
      },
      isForm: true,
      loading: true,
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.success);
      return true;
    } else {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.failed);
      return null;
    }
  }
}
