import 'package:dio/dio.dart';
import '../../utils/utils.dart';
import '../../localization/localization_helper.dart';
import '../../cache/hive_service.dart';
import '../../services/navigation_service.dart';

/// Interceptor for handling authentication
class AuthInterceptor extends Interceptor {
  final String Function()? getToken;
  final String Function()? getLanguage;

  AuthInterceptor({this.getToken, this.getLanguage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication token if available
    final token = getToken?.call() ?? Utils.token;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add language header
    final language =
        getLanguage?.call() ?? LocalizationHelper.currentLocale.languageCode;
    options.headers['lang'] = language;

    // Set Content-Type based on data type
    if (options.data is FormData) {
      options.headers['Content-Type'] = 'multipart/form-data';
    } else if (options.method.toUpperCase() != 'GET') {
      options.headers['Content-Type'] = 'application/json';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 ||
        err.response?.data?.toString().toLowerCase().contains(
              'unauthenticated',
            ) ==
            true) {
      _handleUnauthorized();
    }

    super.onError(err, handler);
  }

  void _handleUnauthorized() async {
    // Clear user data
    final hiveService = HiveService();

    // Clear token
    Utils.token = '';

    // Clear user data from Hive
    await hiveService.delete('user_box', 'user_data');
    await hiveService.delete('user_box', 'token');
    await hiveService.delete('user_box', 'user_type');

    // Navigate to login screen
    try {
      NavigationService.goNamed('login');
    } catch (e) {
      // If navigation fails, just log the error
      print('Navigation error: $e');
    }
  }
}
