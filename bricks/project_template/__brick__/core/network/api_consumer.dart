import '../error/failures.dart';

/// Result type for API responses
class ApiResult<T> {
  final T? data;
  final Failure? failure;

  const ApiResult._({this.data, this.failure});

  factory ApiResult.success(T data) => ApiResult._(data: data);
  factory ApiResult.failure(Failure failure) => ApiResult._(failure: failure);

  bool get isSuccess => data != null && failure == null;
  bool get isFailure => failure != null;

  /// Fold pattern for handling results
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data!);
    } else {
      return onFailure(failure!);
    }
  }

  /// Map the data if successful
  ApiResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      try {
        return ApiResult.success(mapper(data!));
      } catch (e) {
        return ApiResult.failure(UnknownFailure(message: 'Error mapping data'));
      }
    }
    return ApiResult.failure(failure!);
  }
}

/// Abstract API consumer interface
/// All network implementations should implement this interface
abstract class ApiConsumer {
  /// GET request
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  });

  /// POST request
  Future<ApiResult<T>> post<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  });

  /// PUT request
  Future<ApiResult<T>> put<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  });

  /// PATCH request
  Future<ApiResult<T>> patch<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  });

  /// DELETE request
  Future<ApiResult<T>> delete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  });

  /// Upload file
  Future<ApiResult<T>> uploadFile<T>({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    void Function(int sent, int total)? onProgress,
    bool showLoading = false,
  });

  /// Download file
  Future<ApiResult<String>> downloadFile({
    required String path,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    void Function(int received, int total)? onProgress,
    bool showLoading = false,
  });
}
