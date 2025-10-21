import '../models/request/login_request.dart';
import '../models/response/user_model.dart';
import '../../../../core/error/result_extensions.dart';

abstract class AuthRepository {
  Future<Result<UserModel>> login(LoginRequest request);
  Future<Result<UserModel>> register(LoginRequest request);
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword(String code, String newPassword);
  Future<Result<UserModel?>> getCurrentUser();
  Future<Result<void>> logout();
}
