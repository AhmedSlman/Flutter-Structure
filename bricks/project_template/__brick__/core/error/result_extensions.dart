import 'package:dartz/dartz.dart';
import 'failures.dart';

/// Type alias for Either with Failure as Left and T as Right
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result to make it easier to work with
extension ResultExtensions<T> on Result<T> {
  /// Check if the result is a success
  bool get isSuccess => isRight();

  /// Check if the result is a failure
  bool get isFailure => isLeft();

  /// Get the success value or null
  T? get successValue =>
      fold(onFailure: (_) => null, onSuccess: (value) => value);

  /// Get the failure value or null
  Failure? get failureValue =>
      fold(onFailure: (failure) => failure, onSuccess: (_) => null);

  /// Execute a function on success
  Result<R> map<R>(R Function(T) mapper) {
    return fold(
      onFailure: (failure) => Left(failure),
      onSuccess: (value) => Right(mapper(value)),
    );
  }

  /// Execute a function on failure
  Result<T> mapFailure(Failure Function(Failure) mapper) {
    return fold(
      onFailure: (failure) => Left(mapper(failure)),
      onSuccess: (value) => Right(value),
    );
  }

  /// Execute a function on success and return a Result
  Result<R> flatMap<R>(Result<R> Function(T) mapper) {
    return fold(
      onFailure: (failure) => Left(failure),

      onSuccess: (value) => mapper(value),
    );
  }

  /// Get value or throw exception
  T getOrThrow() {
    return fold(
      onFailure: (failure) => throw Exception(failure.message),
      onSuccess: (value) => value,
    );
  }

  /// Get value or return default
  T getOrElse(T defaultValue) {
    return fold(onFailure: (_) => defaultValue, onSuccess: (value) => value);
  }

  /// Get value or return null
  T? getOrNull() {
    return fold(onFailure: (_) => null, onSuccess: (value) => value);
  }

  /// Execute a function on success, ignore failure
  void onSuccess(void Function(T) onSuccess) {
    fold(onFailure: (_) => null, onSuccess: (value) => onSuccess(value));
  }

  /// Execute a function on failure, ignore success
  void onFailure(void Function(Failure) onFailure) {
    fold(onFailure: (failure) => onFailure(failure), onSuccess: (_) => null);
  }

  /// Execute functions on both success and failure
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T value) onSuccess,
  }) {
    return isRight() ? onSuccess(getOrThrow()) : onFailure(failureValue!);
  }
}
