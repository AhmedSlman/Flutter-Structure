import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';

/// Secure storage service for sensitive data (tokens, passwords, etc.)
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Save secure data
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw CacheException(message: 'Failed to write secure data: $e');
    }
  }

  /// Read secure data
  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to read secure data: $e');
    }
  }

  /// Delete secure data
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to delete secure data: $e');
    }
  }

  /// Clear all secure data
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear secure storage: $e');
    }
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to check key: $e');
    }
  }

  /// Read all secure data
  static Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      throw CacheException(message: 'Failed to read all data: $e');
    }
  }

  // Common keys
  static const String keyToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';

  /// Token operations
  static Future<void> saveToken(String token) async {
    await write(keyToken, token);
  }

  static Future<String?> getToken() async {
    return await read(keyToken);
  }

  static Future<void> deleteToken() async {
    await delete(keyToken);
  }

  /// Refresh token operations
  static Future<void> saveRefreshToken(String token) async {
    await write(keyRefreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    return await read(keyRefreshToken);
  }

  /// User ID operations
  static Future<void> saveUserId(String userId) async {
    await write(keyUserId, userId);
  }

  static Future<String?> getUserId() async {
    return await read(keyUserId);
  }

  /// Clear all auth data
  static Future<void> clearAuthData() async {
    await delete(keyToken);
    await delete(keyRefreshToken);
    await delete(keyUserId);
  }
}
