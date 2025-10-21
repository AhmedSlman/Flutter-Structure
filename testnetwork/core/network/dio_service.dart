import 'dart:async';
import 'package:dio/dio.dart';

import '../../../shared/widgets/myLoading.dart';
import '../../services/alerts.dart';
import '../../utils/utils.dart';
import 'api_response.dart';
import 'error_handler.dart';
import 'interceptors.dart';
import 'network_config.dart';

// Assuming these are external dependencies or part of your project structure
// import 'package:your_project/app/router/navigation_helper.dart';
// import 'package:your_project/app/services/alerts.dart';
// import 'package:your_project/app/shared/widgets/myLoading.dart';
// import 'package:your_project/app/utils/utils.dart';

// Placeholder for external dependencies to make the code runnable

// End of placeholders

typedef ResponseParser<T> = T Function(Map<String, dynamic> json);

class DioService {
  late final Dio _dio;
  final NetworkConfig networkConfig;
  final CacheInterceptor _cacheInterceptor;

  DioService({required this.networkConfig})
      : _cacheInterceptor = CacheInterceptor(
          defaultCacheDuration: networkConfig.cacheDuration,
        ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: networkConfig.baseUrl,
        connectTimeout: networkConfig.connectTimeout,
        receiveTimeout: networkConfig.receiveTimeout,
        sendTimeout: networkConfig.sendTimeout,
        headers: networkConfig.defaultHeaders,
        validateStatus: (status) =>
            status! < 400 ||
            status == 401, // Allow 401 to be handled by interceptor
      ),
    );

    _dio.interceptors.addAll([
      if (networkConfig.enableLogging) EnhancedLoggerInterceptor(),
      AuthInterceptor(
        getToken: () => Utils.token,
        getLanguage: () => _getCurrentLocale(),
        onUnauthorized: _handleUnauthenticated,
      ),
      if (networkConfig.enableRetry)
        RetryInterceptor(
          maxRetries: networkConfig.maxRetries,
          retryDelay: networkConfig.retryDelay,
        ),
      if (networkConfig.enableCache) _cacheInterceptor,
    ]);
  }

  String _getCurrentLocale() {
    // Implement your logic to get the current locale
    // For example, using `Localizations.localeOf(NavigationService.context).languageCode`
    // if (NavigationService.context != null && NavigationService.context.mounted) {
    //   return Localizations.localeOf(NavigationService.context).languageCode;
    // }
    return 'en'; // Default to English if context is not available
  }

  void _handleUnauthenticated() async {
    await Utils.dataManager.deleteUserData();
    // if (NavigationService.context != null && NavigationService.context.mounted) {
    //   Navigator.of(NavigationService.context).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
    // }
    Alerts.snack(
      text: 'Session expired. Please login again.',
      state: SnackState.failed,
    );
  }

  Future<ApiResponse<T>> request<T>({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    ResponseParser<T>? parser,
    RequestConfig? config,
  }) async {
    config ??= const RequestConfig(); // Use default config if not provided

    if (config.loading) MyLoading.show();

    try {
      final options = Options(
        method: method,
        headers: config.customHeaders,
        extra: {
          if (config.enableCache) 'cacheDuration': config.cacheDuration,
          if (config.enableRetry) 'maxRetries': config.maxRetries,
        },
      );

      dynamic requestData = body;
      if (config.isForm) {
        requestData = FormData.fromMap(body ?? {});
      } else if (config.isFile) {
        // Handle file specific logic if needed, e.g., for multipart requests
        // For now, assuming FormData handles file uploads as well
        requestData = FormData.fromMap(body ?? {});
      }

      final response = await _dio.request(
        url,
        data: requestData,
        queryParameters: queryParameters,
        options: options,
      );

      if (config.loading) MyLoading.dismis();

      // Check for success based on API response structure (e.g., 'status' field)
      if (response.data is Map<String, dynamic> &&
          (response.data['status'] == true || response.statusCode == 200)) {
        return ApiResponse.success(
          parser != null ? parser(response.data) : response.data as T,
          rawResponse: response,
        );
      } else {
        // Handle API-specific errors (e.g., status: false, with a message)
        final message = response.data['message'] ?? 'An API error occurred.';
        final error = NetworkException(
          message: message,
          type: NetworkErrorType.badResponse,
          statusCode: response.statusCode,
          errorData: response.data,
        );
        Alerts.snack(text: message, state: SnackState.failed);
        return ApiResponse.failure(error, rawResponse: response);
      }
    } on DioException catch (e) {
      if (config.loading) MyLoading.dismis();
      final networkException = NetworkErrorHandler.handleDioException(e);
      Alerts.snack(text: networkException.message, state: SnackState.failed);
      return ApiResponse.failure(networkException, rawResponse: e.response);
    } catch (e, stackTrace) {
      if (config.loading) MyLoading.dismis();
      final networkException = NetworkErrorHandler.handleGeneralException(
        e,
        stackTrace,
      );
      Alerts.snack(text: networkException.message, state: SnackState.failed);
      return ApiResponse.failure(networkException);
    }
  }

  Future<ApiResponse<T>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    ResponseParser<T>? parser,
    RequestConfig? config,
  }) {
    return request<T>(
      method: 'GET',
      url: url,
      queryParameters: queryParameters,
      parser: parser,
      config: config ?? RequestConfig.get,
    );
  }

  Future<ApiResponse<T>> post<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    ResponseParser<T>? parser,
    RequestConfig? config,
  }) {
    return request<T>(
      method: 'POST',
      url: url,
      body: body,
      queryParameters: queryParameters,
      parser: parser,
      config: config ?? RequestConfig.post,
    );
  }

  Future<ApiResponse<T>> put<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    ResponseParser<T>? parser,
    RequestConfig? config,
  }) {
    return request<T>(
      method: 'PUT',
      url: url,
      body: body,
      queryParameters: queryParameters,
      parser: parser,
      config: config ?? RequestConfig.post,
    );
  }

  Future<ApiResponse<T>> delete<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    ResponseParser<T>? parser,
    RequestConfig? config,
  }) {
    return request<T>(
      method: 'DELETE',
      url: url,
      queryParameters: queryParameters,
      parser: parser,
      config: config ?? RequestConfig.post,
    );
  }

  // Method to clear the cache (if caching is enabled)
  void clearCache() {
    _cacheInterceptor.clearCache();
  }
}
