/// Base exception class for application-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Server exception (5xx errors)
class ServerException extends AppException {
  const ServerException({
    String? message,
    super.code = 'SERVER_ERROR',
    super.originalError,
  }) : super(message: message ?? 'Server error occurred');
}

/// Network exception (connection issues)
class NetworkException extends AppException {
  const NetworkException({
    String? message,
    super.code = 'NETWORK_ERROR',
    super.originalError,
  }) : super(message: message ?? 'Network error occurred');
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    String? message,
    super.code = 'CACHE_ERROR',
    super.originalError,
  }) : super(message: message ?? 'Cache error occurred');
}

/// Unauthorized exception (401)
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String? message,
    super.code = 'UNAUTHORIZED',
    super.originalError,
  }) : super(message: message ?? 'Unauthorized access');
}

/// Forbidden exception (403)
class ForbiddenException extends AppException {
  const ForbiddenException({
    String? message,
    super.code = 'FORBIDDEN',
    super.originalError,
  }) : super(message: message ?? 'Access forbidden');
}

/// Not found exception (404)
class NotFoundException extends AppException {
  const NotFoundException({
    String? message,
    super.code = 'NOT_FOUND',
    super.originalError,
  }) : super(message: message ?? 'Resource not found');
}

/// Validation exception (422)
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    String? message,
    super.code = 'VALIDATION_ERROR',
    this.errors,
    super.originalError,
  }) : super(message: message ?? 'Validation error occurred');
}

/// Timeout exception
class TimeoutException extends AppException {
  const TimeoutException({
    String? message,
    super.code = 'TIMEOUT',
    super.originalError,
  }) : super(message: message ?? 'Request timeout');
}

/// Bad request exception (400)
class BadRequestException extends AppException {
  const BadRequestException({
    String? message,
    super.code = 'BAD_REQUEST',
    super.originalError,
  }) : super(message: message ?? 'Bad request');
}
