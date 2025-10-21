import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Enum for different types of network errors
enum NetworkErrorType {
  connectionTimeout,
  receiveTimeout,
  sendTimeout,
  badResponse,
  connectionError,
  cancel,
  unknown,
  noInternet,
  unauthorized,
  forbidden,
  notFound,
  internalServerError,
  badRequest,
  conflict,
  unprocessableEntity,
  tooManyRequests,
  serviceUnavailable,
  parsing,
}

/// Custom exception class for network errors
class NetworkException implements Exception {
  final String message;
  final NetworkErrorType type;
  final int? statusCode;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? errorData;

  const NetworkException({
    required this.message,
    required this.type,
    this.statusCode,
    this.originalError,
    this.stackTrace,
    this.errorData,
  });

  @override
  String toString() {
    return 'NetworkException: $message (Type: $type, Status: $statusCode)';
  }
}

/// Result wrapper for network operations
class NetworkResult<T> {
  final T? data;
  final NetworkException? error;
  final bool isSuccess;

  const NetworkResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory NetworkResult.success(T data) {
    return NetworkResult._(data: data, isSuccess: true);
  }

  factory NetworkResult.failure(NetworkException error) {
    return NetworkResult._(error: error, isSuccess: false);
  }

  /// Fold pattern for handling results
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(NetworkException error) onError,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data!);
    } else {
      return onError(error!);
    }
  }

  /// Map the data if successful
  NetworkResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      try {
        return NetworkResult.success(mapper(data!));
      } catch (e, stackTrace) {
        return NetworkResult.failure(
          NetworkException(
            message: 'Error mapping data: ${e.toString()}',
            type: NetworkErrorType.parsing,
            originalError: e,
            stackTrace: stackTrace,
          ),
        );
      }
    }
    return NetworkResult.failure(error!);
  }
}

/// Comprehensive error handler for Dio exceptions
class NetworkErrorHandler {
  static const Map<NetworkErrorType, String> _errorMessages = {
    NetworkErrorType.connectionTimeout: 'Connection timeout. Please try again.',
    NetworkErrorType.receiveTimeout: 'Receive timeout. Please try again.',
    NetworkErrorType.sendTimeout: 'Send timeout. Please try again.',
    NetworkErrorType.connectionError: 'Connection error. Please check your internet connection.',
    NetworkErrorType.noInternet: 'No internet connection. Please check your network.',
    NetworkErrorType.unauthorized: 'Unauthorized access. Please login again.',
    NetworkErrorType.forbidden: 'Access forbidden. You don\'t have permission.',
    NetworkErrorType.notFound: 'Resource not found.',
    NetworkErrorType.badRequest: 'Bad request. Please check your input.',
    NetworkErrorType.internalServerError: 'Internal server error. Please try again later.',
    NetworkErrorType.conflict: 'Conflict occurred. Please try again.',
    NetworkErrorType.unprocessableEntity: 'Invalid data provided.',
    NetworkErrorType.tooManyRequests: 'Too many requests. Please wait and try again.',
    NetworkErrorType.serviceUnavailable: 'Service temporarily unavailable.',
    NetworkErrorType.cancel: 'Request was cancelled.',
    NetworkErrorType.unknown: 'An unexpected error occurred.',
    NetworkErrorType.parsing: 'Error parsing response data.',
  };

  /// Handle DioException and convert to NetworkException
  static NetworkException handleDioException(DioException dioException) {
    NetworkErrorType errorType;
    String message;
    int? statusCode = dioException.response?.statusCode;
    Map<String, dynamic>? errorData;

    // Extract error data from response if available
    if (dioException.response?.data is Map<String, dynamic>) {
      errorData = dioException.response!.data as Map<String, dynamic>;
    }

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        errorType = NetworkErrorType.connectionTimeout;
        message = _errorMessages[errorType]!;
        break;

      case DioExceptionType.receiveTimeout:
        errorType = NetworkErrorType.receiveTimeout;
        message = _errorMessages[errorType]!;
        break;

      case DioExceptionType.sendTimeout:
        errorType = NetworkErrorType.sendTimeout;
        message = _errorMessages[errorType]!;
        break;

      case DioExceptionType.badResponse:
        errorType = _getErrorTypeFromStatusCode(statusCode);
        message = _getMessageFromResponse(dioException.response) ?? 
                  _errorMessages[errorType]!;
        break;

      case DioExceptionType.cancel:
        errorType = NetworkErrorType.cancel;
        message = _errorMessages[errorType]!;
        break;

      case DioExceptionType.connectionError:
        if (_isNoInternetError(dioException.error)) {
          errorType = NetworkErrorType.noInternet;
          message = _errorMessages[errorType]!;
        } else {
          errorType = NetworkErrorType.connectionError;
          message = _errorMessages[errorType]!;
        }
        break;

      case DioExceptionType.unknown:
      default:
        // Handle the problematic DioExceptionType.unknown
        if (_isNoInternetError(dioException.error)) {
          errorType = NetworkErrorType.noInternet;
          message = _errorMessages[errorType]!;
        } else if (dioException.error is SocketException) {
          errorType = NetworkErrorType.connectionError;
          message = _errorMessages[errorType]!;
        } else if (dioException.error is FormatException) {
          errorType = NetworkErrorType.parsing;
          message = 'Invalid response format received from server.';
        } else {
          errorType = NetworkErrorType.unknown;
          message = _errorMessages[errorType]!;
          
          // Log unknown errors for debugging in development
          if (kDebugMode) {
            print('Unknown DioException: ${dioException.error}');
            print('Stack trace: ${dioException.stackTrace}');
          }
        }
        break;
    }

    return NetworkException(
      message: message,
      type: errorType,
      statusCode: statusCode,
      originalError: dioException,
      stackTrace: dioException.stackTrace,
      errorData: errorData,
    );
  }

  /// Handle general exceptions
  static NetworkException handleGeneralException(
    dynamic error, 
    StackTrace? stackTrace
  ) {
    if (error is NetworkException) {
      return error;
    }

    String message = 'An unexpected error occurred.';
    NetworkErrorType type = NetworkErrorType.unknown;

    if (error is SocketException) {
      type = NetworkErrorType.noInternet;
      message = _errorMessages[type]!;
    } else if (error is FormatException) {
      type = NetworkErrorType.parsing;
      message = 'Error parsing data: ${error.message}';
    } else if (error is TimeoutException) {
      type = NetworkErrorType.connectionTimeout;
      message = _errorMessages[type]!;
    }

    return NetworkException(
      message: message,
      type: type,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Get error type from HTTP status code
  static NetworkErrorType _getErrorTypeFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return NetworkErrorType.badRequest;
      case 401:
        return NetworkErrorType.unauthorized;
      case 403:
        return NetworkErrorType.forbidden;
      case 404:
        return NetworkErrorType.notFound;
      case 409:
        return NetworkErrorType.conflict;
      case 422:
        return NetworkErrorType.unprocessableEntity;
      case 429:
        return NetworkErrorType.tooManyRequests;
      case 500:
        return NetworkErrorType.internalServerError;
      case 503:
        return NetworkErrorType.serviceUnavailable;
      default:
        return NetworkErrorType.badResponse;
    }
  }

  /// Extract message from response
  static String? _getMessageFromResponse(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      return data['message'] ?? data['error'] ?? data['msg'];
    }
    return null;
  }

  /// Check if error is related to no internet connection
  static bool _isNoInternetError(dynamic error) {
    if (error is SocketException) {
      return error.osError?.errorCode == 7 || // No address associated with hostname
             error.osError?.errorCode == 8 || // nodename nor servname provided
             error.osError?.errorCode == 110 || // Connection timed out
             error.osError?.errorCode == 111; // Connection refused
    }
    
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socketexception') ||
           errorString.contains('network is unreachable') ||
           errorString.contains('no address associated with hostname') ||
           errorString.contains('connection refused') ||
           errorString.contains('connection timed out');
  }

  /// Get user-friendly message for error type
  static String getUserFriendlyMessage(NetworkErrorType type, [String? customMessage]) {
    return customMessage ?? _errorMessages[type] ?? _errorMessages[NetworkErrorType.unknown]!;
  }

  /// Check if error should trigger logout
  static bool shouldLogout(NetworkException exception) {
    return exception.type == NetworkErrorType.unauthorized ||
           (exception.statusCode == 401) ||
           (exception.errorData?['message']?.toString().toLowerCase().contains('unauthenticated') ?? false);
  }
}

