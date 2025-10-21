import '../data_source/local/auth_local_data_source.dart';
import '../data_source/remote/auth_remote_data_source.dart';
import '../models/request/login_request.dart';
import '../models/response/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result_extensions.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<UserModel>> login(LoginRequest request) async {
    try {
      final result = await remoteDataSource.login(request);

      return result.fold((failure) => Left(failure), (user) async {
        await localDataSource.saveUser(user);
        return Right(user);
      });
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
      final result = await remoteDataSource.register(request);

      return result.fold((failure) => Left(failure), (user) async {
        await localDataSource.saveUser(user);
        return Right(user);
      });
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
      final result = await remoteDataSource.forgotPassword(email);
      return result;
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
      final result = await remoteDataSource.resetPassword(code, newPassword);
      return result;
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to reset password: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to get current user: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to logout: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
