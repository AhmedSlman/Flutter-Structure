import '../../../../../core/error/result_extensions.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result_extensions.dart';
import '../../models/request/login_request.dart';
import '../../models/response/user_model.dart';
import '../models/request/login_request.dart';
import '../models/response/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<UserModel>> login(LoginRequest request);
  Future<Result<UserModel>> register(LoginRequest request);
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword(String code, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AuthRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<UserModel>> login(LoginRequest request) async {
    try {
      final result = await _apiConsumer.post<UserModel>(
        path: '/auth/login',
        body: request.toJson(),
        parser: (json) => UserModel.fromJson(json['data']),
        showLoading: true,
      );

      return result.fold(
        onSuccess: (data) => Right(data),
        onFailure: (failure) => Left(failure),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to login: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<UserModel>> register(LoginRequest request) async {
    try {
      final result = await _apiConsumer.post<UserModel>(
        path: '/auth/register',
        body: request.toJson(),
        parser: (json) => UserModel.fromJson(json['data']),
        showLoading: true,
      );

      return result.fold(
        onSuccess: (data) => Right(data),
        onFailure: (failure) => Left(failure),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to register: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      final result = await _apiConsumer.post<void>(
        path: '/auth/forgot-password',
        body: {'email': email},
        showLoading: true,
      );

      return result.fold(
        onSuccess: (_) => const Right(null),
        onFailure: (failure) => Left(failure),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to send reset password email: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> resetPassword(String code, String newPassword) async {
    try {
      final result = await _apiConsumer.post<void>(
        path: '/auth/reset-password',
        body: {'code': code, 'password': newPassword},
        showLoading: true,
      );

      return result.fold(
        onSuccess: (_) => const Right(null),
        onFailure: (failure) => Left(failure),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to reset password: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
