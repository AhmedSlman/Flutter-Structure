import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

/// Base failure class for all application failures
/// Inspired by Clean Architecture principles
@immutable
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ (code?.hashCode ?? 0);

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

/// Server-related failures (5xx errors)
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({
    String? message,
    super.code = 'SERVER_ERROR',
    this.statusCode,
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'server_error_occurred'.tr());
}

/// Network-related failures (connection issues)
class NetworkFailure extends Failure {
  NetworkFailure({
    String? message,
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'network_connection_error'.tr());
}

/// No internet connection failure
class NoInternetFailure extends Failure {
  NoInternetFailure({
    String? message,
    super.code = 'NO_INTERNET',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'no_internet_connection'.tr());
}

/// Timeout failures
class TimeoutFailure extends Failure {
  TimeoutFailure({
    String? message,
    super.code = 'TIMEOUT',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'connection_timeout'.tr());
}

/// Cache-related failures
class CacheFailure extends Failure {
  CacheFailure({
    String? message,
    super.code = 'CACHE_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'cache_error_occurred'.tr());
}

/// Authentication failures (401)
class AuthFailure extends Failure {
  AuthFailure({
    String? message,
    super.code = 'AUTH_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'authentication_failed'.tr());
}

/// Authorization failures (403)
class PermissionFailure extends Failure {
  PermissionFailure({
    String? message,
    super.code = 'PERMISSION_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'no_permission_access_resource'.tr());
}

/// Not found failures (404)
class NotFoundFailure extends Failure {
  NotFoundFailure({
    String? message,
    super.code = 'NOT_FOUND',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'resource_not_found'.tr());
}

/// Validation failures (422)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  ValidationFailure({
    String? message,
    super.code = 'VALIDATION_ERROR',
    this.errors,
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'invalid_input_data'.tr());
}

/// Bad request failures (400)
class BadRequestFailure extends Failure {
  BadRequestFailure({
    String? message,
    super.code = 'BAD_REQUEST',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'bad_request'.tr());
}

/// No data available failure
class NoDataFailure extends Failure {
  NoDataFailure({
    String? message,
    super.code = 'NO_DATA',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'no_data_available'.tr());
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  UnknownFailure({
    String? message,
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'unexpected_error_occurred'.tr());
}

/// Extension methods for Failure
extension FailureExtensions on Failure {
  /// Check if failure is network related
  bool get isNetworkError =>
      this is NetworkFailure ||
      this is NoInternetFailure ||
      this is TimeoutFailure;

  /// Check if failure is server related
  bool get isServerError => this is ServerFailure;

  /// Check if failure is cache related
  bool get isCacheError => this is CacheFailure;

  /// Check if failure is validation related
  bool get isValidationError => this is ValidationFailure;

  /// Check if failure is authentication related
  bool get isAuthError => this is AuthFailure || this is PermissionFailure;

  /// Check if failure requires logout
  bool get shouldLogout => this is AuthFailure;

  /// Get user-friendly error message
  String get userMessage {
    if (isNetworkError) {
      return 'check_internet_connection'.tr();
    } else if (isServerError) {
      return 'server_error_try_later'.tr();
    } else if (isAuthError) {
      return 'please_login_again'.tr();
    } else if (isValidationError) {
      return 'check_input_data'.tr();
    } else {
      return message;
    }
  }

  /// Get validation errors if available
  Map<String, List<String>>? get validationErrors {
    if (this is ValidationFailure) {
      return (this as ValidationFailure).errors;
    }
    return null;
  }
}
