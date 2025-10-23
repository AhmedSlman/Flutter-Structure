import 'package:flutter/foundation.dart';
import '../localization/localization_helper.dart';

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

  const ServerFailure({
    String? message,
    super.code = 'SERVER_ERROR',
    this.statusCode,
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً' : 'Server error occurred, please try again later'));
}

/// Network-related failures (connection issues)
class NetworkFailure extends Failure {
  const NetworkFailure({
    String? message,
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'حدث خطأ في الاتصال بالإنترنت' : 'Network connection error'));
}

/// No internet connection failure
class NoInternetFailure extends Failure {
  const NoInternetFailure({
    String? message,
    super.code = 'NO_INTERNET',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'لا يوجد اتصال بالإنترنت' : 'No internet connection'));
}

/// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String? message,
    super.code = 'TIMEOUT',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى' : 'Connection timeout, please try again'));
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    String? message,
    super.code = 'CACHE_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'حدث خطأ في التخزين المؤقت' : 'Cache error occurred'));
}

/// Authentication failures (401)
class AuthFailure extends Failure {
  const AuthFailure({
    String? message,
    super.code = 'AUTH_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(
         message: message ?? (EasyLocalization.isArabic ? 'فشلت عملية المصادقة، يرجى تسجيل الدخول مرة أخرى' : 'Authentication failed, please login again'),
       );
}

/// Authorization failures (403)
class PermissionFailure extends Failure {
  const PermissionFailure({
    String? message,
    super.code = 'PERMISSION_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'ليس لديك صلاحية للوصول إلى هذا المورد' : 'You do not have permission to access this resource'));
}

/// Not found failures (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String? message,
    super.code = 'NOT_FOUND',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'المورد المطلوب غير موجود' : 'The requested resource was not found'));
}

/// Validation failures (422)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    String? message,
    super.code = 'VALIDATION_ERROR',
    this.errors,
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? (EasyLocalization.isArabic ? 'البيانات المدخلة غير صحيحة' : 'Invalid input data'));
}

/// Bad request failures (400)
class BadRequestFailure extends Failure {
  const BadRequestFailure({
    String? message,
    super.code = 'BAD_REQUEST',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'الطلب غير صحيح');
}

/// No data available failure
class NoDataFailure extends Failure {
  const NoDataFailure({
    String? message,
    super.code = 'NO_DATA',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'لا توجد بيانات متاحة');
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    String? message,
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
    super.stackTrace,
  }) : super(message: message ?? 'حدث خطأ غير متوقع');
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
      return 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
    } else if (isServerError) {
      return 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً';
    } else if (isAuthError) {
      return 'يرجى تسجيل الدخول مرة أخرى';
    } else if (isValidationError) {
      return 'يرجى التحقق من البيانات المدخلة';
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
