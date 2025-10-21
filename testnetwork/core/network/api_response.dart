import 'package:dio/dio.dart';
import 'package:improved_dio_solution/core/network/error_handler.dart';

/// A unified response wrapper for API calls.
/// This class combines the success data, error information, and raw Dio response.
class ApiResponse<T> {
  final T? data;
  final NetworkException? error;
  final Response? rawResponse;

  /// Private constructor for internal use.
  ApiResponse._({this.data, this.error, this.rawResponse});

  /// Factory constructor for a successful API response.
  factory ApiResponse.success(T data, {Response? rawResponse}) {
    return ApiResponse._(data: data, rawResponse: rawResponse);
  }

  /// Factory constructor for a failed API response.
  factory ApiResponse.failure(NetworkException error, {Response? rawResponse}) {
    return ApiResponse._(error: error, rawResponse: rawResponse);
  }

  /// Returns true if the response is a success, false otherwise.
  bool get isSuccess => data != null && error == null;

  /// Returns true if the response is an error, false otherwise.
  bool get isError => error != null;

  /// Helper to get the user-friendly error message.
  String? get errorMessage => error != null 
      ? NetworkErrorHandler.getUserFriendlyMessage(error!.type, error!.message)
      : null;
}


