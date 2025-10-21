import 'package:shared_preferences/shared_preferences.dart';
import '../error/exceptions.dart';

/// Helper class for managing simple cache using SharedPreferences
class CacheHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save string data
  static Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to save string: $e');
    }
  }

  /// Get string data
  static String? getString(String key) {
    try {
      return _prefs?.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string: $e');
    }
  }

  /// Save int data
  static Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs?.setInt(key, value) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to save int: $e');
    }
  }

  /// Get int data
  static int? getInt(String key) {
    try {
      return _prefs?.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get int: $e');
    }
  }

  /// Save bool data
  static Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs?.setBool(key, value) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to save bool: $e');
    }
  }

  /// Get bool data
  static bool? getBool(String key) {
    try {
      return _prefs?.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get bool: $e');
    }
  }

  /// Save double data
  static Future<bool> saveDouble(String key, double value) async {
    try {
      return await _prefs?.setDouble(key, value) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to save double: $e');
    }
  }

  /// Get double data
  static double? getDouble(String key) {
    try {
      return _prefs?.getDouble(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get double: $e');
    }
  }

  /// Save string list
  static Future<bool> saveStringList(String key, List<String> value) async {
    try {
      return await _prefs?.setStringList(key, value) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to save string list: $e');
    }
  }

  /// Get string list
  static List<String>? getStringList(String key) {
    try {
      return _prefs?.getStringList(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string list: $e');
    }
  }

  /// Remove specific key
  static Future<bool> remove(String key) async {
    try {
      return await _prefs?.remove(key) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: $e');
    }
  }

  /// Clear all data
  static Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }

  /// Check if key exists
  static bool containsKey(String key) {
    try {
      return _prefs?.containsKey(key) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to check key: $e');
    }
  }

  /// Get all keys
  static Set<String> getKeys() {
    try {
      return _prefs?.getKeys() ?? {};
    } catch (e) {
      throw CacheException(message: 'Failed to get keys: $e');
    }
  }
}
