import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for automatic retry on failed requests
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [500, 502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    final requestOptions = err.requestOptions;

    if (shouldRetry && _getRetryCount(requestOptions) < maxRetries) {
      _incrementRetryCount(requestOptions);

      if (kDebugMode) {
        debugPrint(
          'Retrying request: ${requestOptions.path} '
          '(${_getRetryCount(requestOptions)}/$maxRetries)',
        );
      }

      await Future.delayed(retryDelay);

      try {
        final response = await Dio().fetch(requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with error
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null &&
            retryStatusCodes.contains(err.response!.statusCode));
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retryCount'] as int? ?? 0;
  }

  void _incrementRetryCount(RequestOptions options) {
    options.extra['retryCount'] = _getRetryCount(options) + 1;
  }
}
