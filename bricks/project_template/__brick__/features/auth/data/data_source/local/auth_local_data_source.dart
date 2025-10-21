import '../../../../core/cache/hive_service.dart';
import '../models/response/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveService _hiveService;

  AuthLocalDataSourceImpl() : _hiveService = HiveService();

  @override
  Future<void> saveUser(UserModel user) async {
    await _hiveService.put('auth_box', 'current_user', user.toJson());
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userData = await _hiveService.get('auth_box', 'current_user');
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await _hiveService.delete('auth_box', 'current_user');
  }

  @override
  Future<void> saveToken(String token) async {
    await _hiveService.put('auth_box', 'auth_token', token);
  }

  @override
  Future<String?> getToken() async {
    return await _hiveService.get('auth_box', 'auth_token');
  }
}
