import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

/// Retry interceptor for handling failed requests
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;
  final void Function(String message)? logPrint;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
    this.logPrint,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra =
        RetryOptions.fromExtra(err.requestOptions) ??
        RetryOptions(retries: retries, retryDelays: retryDelays);

    final shouldRetry = extra.retries > 0 && _shouldRetry(err);
    if (!shouldRetry) {
      return handler.next(err);
    }

    final delay = _getDelay(extra);
    logPrint?.call('Retrying request after ${delay.inMilliseconds}ms');

    await Future.delayed(delay);

    try {
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        final newExtra = extra.copyWith(retries: extra.retries - 1);
        err.requestOptions.extra = newExtra.toExtra();
        return onError(e, handler);
      }
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.badResponse &&
            err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }

  Duration _getDelay(RetryOptions options) {
    if (options.retryDelays.isEmpty) {
      return Duration(seconds: 1);
    }

    final retryCount = options.retries;
    final delayIndex = min(retryCount - 1, options.retryDelays.length - 1);
    return options.retryDelays[delayIndex];
  }
}

class RetryOptions {
  final int retries;
  final List<Duration> retryDelays;

  const RetryOptions({required this.retries, required this.retryDelays});

  RetryOptions copyWith({int? retries, List<Duration>? retryDelays}) {
    return RetryOptions(
      retries: retries ?? this.retries,
      retryDelays: retryDelays ?? this.retryDelays,
    );
  }

  Map<String, dynamic> toExtra() {
    return {'retry_options': this};
  }

  static RetryOptions? fromExtra(RequestOptions request) {
    return request.extra['retry_options'] as RetryOptions?;
  }
}
