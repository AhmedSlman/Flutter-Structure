import 'dart:io';
import 'package:dio/dio.dart';
import 'failures.dart';
import 'exceptions.dart';
import '../localization/localization_helper.dart';

/// Converts exceptions to failures
class ErrorHandler {
  /// Convert DioException to Failure
  static Failure handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return NoInternetFailure(
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        return NetworkFailure(
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.cancel:
        return UnknownFailure(
          message: LocalizationHelper.isArabic ? 'تم إلغاء الطلب' : 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          message: LocalizationHelper.isArabic ? 'خطأ في شهادة الأمان' : 'Bad certificate',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NoInternetFailure(
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        return UnknownFailure(
          message: error.message,
          originalError: error,
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Handle HTTP response errors based on status code
  static Failure _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Extract message from response
    String? message;
    Map<String, List<String>>? validationErrors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['msg'];

      // Extract validation errors
      if (data['errors'] is Map) {
        validationErrors = (data['errors'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            value is List
                ? value.map((e) => e.toString()).toList()
                : [value.toString()],
          ),
        );
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 401:
        return AuthFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 403:
        return PermissionFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 404:
        return NotFoundFailure(
          message: message,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 422:
        return ValidationFailure(
          message: message,
          errors: validationErrors,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case 429:
        return ServerFailure(
          message: LocalizationHelper.isArabic ? 'تم تجاوز عدد الطلبات المسموح بها' : 'Too many requests',
          code: 'TOO_MANY_REQUESTS',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      default:
        return UnknownFailure(
          message: message ?? (LocalizationHelper.isArabic ? 'حدث خطأ غير متوقع' : 'Unexpected error occurred'),
          code: 'HTTP_$statusCode',
          originalError: error,
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Convert app exceptions to failures
  static Failure handleException(
    Exception exception, [
    StackTrace? stackTrace,
  ]) {
    if (exception is AppException) {
      return _mapExceptionToFailure(exception, stackTrace);
    }

    if (exception is DioException) {
      return handleDioException(exception);
    }

    if (exception is SocketException) {
      return NoInternetFailure(
        originalError: exception,
        stackTrace: stackTrace,
      );
    }

    if (exception is FormatException) {
      return UnknownFailure(
        message: LocalizationHelper.isArabic ? 'خطأ في تنسيق البيانات' : 'Data format error',
        code: 'FORMAT_ERROR',
      );
    }

    return UnknownFailure(
      message: exception.toString(),
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  /// Map AppException to Failure
  static Failure _mapExceptionToFailure(
    AppException exception,
    StackTrace? stackTrace,
  ) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is UnauthorizedException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is ForbiddenException) {
      return PermissionFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is NotFoundException) {
      return NotFoundFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        errors: exception.errors,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    if (exception is BadRequestException) {
      return BadRequestFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
        stackTrace: stackTrace,
      );
    }

    return UnknownFailure(
      message: exception.message,
      code: exception.code,
      originalError: exception.originalError,
      stackTrace: stackTrace,
    );
  }
}
