import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_consumer.dart';
import 'network_config.dart';
import '../error/error_handler.dart';
import '../error/failures.dart';
import '../localization/localization_helper.dart';
import '../services/alerts.dart';
import '../../shared/widgets/myLoading.dart';
import '../utils/utils.dart';

/// Comprehensive Dio implementation of ApiConsumer
class DioConsumer implements ApiConsumer {
  late final Dio _dio;
  final NetworkConfig config;

  DioConsumer({required this.config}) {
    _dio = Dio();
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: _getDefaultHeaders(),
      validateStatus: (status) =>
          status != null &&
          (status < 400 || status == 302), // 302 is redirect, treat as success
      followRedirects: true,
      receiveDataWhenStatusError: true,
    );

    // Add logging interceptor
    if (config.enableLogging && kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Map<String, dynamic> _getDefaultHeaders() {
    return {
      "Accept": "application/json",
      "lang": EasyLocalization.of(context)?.locale.languageCode ?? "en",
      "Content-Type": "application/json",
      ...config.defaultHeaders,
    };
  }

  void _updateHeaders({required String method, bool isFile = false}) {
    final defaultHeaders = _getDefaultHeaders();
    _dio.options.headers = {
      ...defaultHeaders,
      if (Utils.token.isNotEmpty) "Authorization": 'Bearer ${Utils.token}',
    };

    // Avoid adding Content-Type for GET requests
    if (method.toUpperCase() != 'GET') {
      if (isFile) {
        _dio.options.headers["Content-Type"] = "multipart/form-data";
      } else {
        _dio.options.headers["Content-Type"] = "application/json";
      }
    }
  }

  Future<ApiResult<T>> _handleRequest<T>({
    required Future<Response> Function() request,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) MyLoading.show();
      final response = await request();
      if (showLoading) MyLoading.dismis();

      if (parser != null) {
        return ApiResult.success(parser(response.data));
      }
      return ApiResult.success(response.data as T);
    } catch (e) {
      if (showLoading) MyLoading.dismis();
      if (e is DioException) {
        return ApiResult.failure(ErrorHandler.handleDioException(e));
      }
      return ApiResult.failure(
        UnknownFailure(
          message: e.toString(),
          originalError: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) {
    _updateHeaders(method: 'GET');
    return _handleRequest<T>(
      request: () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      parser: parser,
      showLoading: showLoading,
    );
  }

  @override
  Future<ApiResult<T>> post<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  }) {
    _updateHeaders(method: 'POST', isFile: isFormData);
    return _handleRequest<T>(
      request: () => _dio.post(
        path,
        data: isFormData ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      parser: parser,
      showLoading: showLoading,
    );
  }

  @override
  Future<ApiResult<T>> put<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  }) {
    _updateHeaders(method: 'PUT', isFile: isFormData);
    return _handleRequest<T>(
      request: () => _dio.put(
        path,
        data: isFormData ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      parser: parser,
      showLoading: showLoading,
    );
  }

  @override
  Future<ApiResult<T>> patch<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  }) {
    _updateHeaders(method: 'PATCH', isFile: isFormData);
    return _handleRequest<T>(
      request: () => _dio.patch(
        path,
        data: isFormData ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      parser: parser,
      showLoading: showLoading,
    );
  }

  @override
  Future<ApiResult<T>> delete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) {
    _updateHeaders(method: 'DELETE');
    return _handleRequest<T>(
      request: () => _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      parser: parser,
      showLoading: showLoading,
    );
  }

  @override
  Future<ApiResult<T>> uploadFile<T>({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    void Function(int sent, int total)? onProgress,
    bool showLoading = false,
  }) {
    _updateHeaders(method: 'POST', isFile: true);
    return _handleRequest<T>(
      request: () => _dio.post(
        path,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onSendProgress: onProgress,
      ),
      parser: parser,
      showLoading: showLoading,
    );
  }

  @override
  Future<ApiResult<String>> downloadFile({
    required String path,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    void Function(int received, int total)? onProgress,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) MyLoading.show();

      _updateHeaders(method: 'GET');
      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onProgress,
      );

      if (showLoading) MyLoading.dismis();
      return ApiResult.success(savePath);
    } on DioException catch (e) {
      if (showLoading) MyLoading.dismis();
      return ApiResult.failure(ErrorHandler.handleDioException(e));
    } catch (e, stackTrace) {
      if (showLoading) MyLoading.dismis();
      return ApiResult.failure(
        UnknownFailure(
          message: e.toString(),
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Additional convenience methods for backward compatibility
  Future<ApiResult<T?>> getData<T>({
    required String url,
    Map<String, dynamic>? query,
    T Function(Map<String, dynamic>)? parser,
    bool loading = false,
  }) {
    return get<T>(
      path: url,
      queryParameters: query,
      parser: parser,
      showLoading: loading,
    );
  }

  Future<ApiResult<T?>> postData<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
    bool isFile = false,
    T Function(Map<String, dynamic>)? parser,
  }) {
    return post<T>(
      path: url,
      body: body,
      queryParameters: query,
      showLoading: loading,
      isFormData: isForm || isFile,
      parser: parser,
    );
  }

  Future<ApiResult<T?>> putData<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
    T Function(Map<String, dynamic>)? parser,
  }) {
    return put<T>(
      path: url,
      body: body,
      queryParameters: query,
      showLoading: loading,
      isFormData: isForm,
      parser: parser,
    );
  }

  Future<ApiResult<T?>> deleteData<T>({
    required String url,
    Map<String, dynamic>? query,
    T Function(Map<String, dynamic>)? parser,
    bool loading = false,
  }) {
    return delete<T>(
      path: url,
      queryParameters: query,
      parser: parser,
      showLoading: loading,
    );
  }
}
