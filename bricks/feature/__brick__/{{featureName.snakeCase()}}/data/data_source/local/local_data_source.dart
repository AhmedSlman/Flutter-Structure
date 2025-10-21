import '../../../../../core/cache/hive_service.dart';
import '../../models/response/{{featureName.snakeCase()}}_model.dart';

abstract class {{featureName.pascalCase()}}LocalDataSource {
  Future<void> cacheItems(List<{{featureName.pascalCase()}}Model> items);
  Future<List<{{featureName.pascalCase()}}Model>> getCachedItems();
  Future<void> clearCache();
  Future<void> logCache();
}

class {{featureName.pascalCase()}}LocalDataSourceImpl implements {{featureName.pascalCase()}}LocalDataSource {
  final HiveService _hiveService = HiveService();
  static const String _boxName = '{{featureName.snakeCase()}}_box';
  static const String _dataKey = '{{featureName.snakeCase()}}_data';

  @override
  Future<void> cacheItems(List<{{featureName.pascalCase()}}Model> items) async {
    try {
      final data = items.map((item) => item.toJson()).toList();
      await _hiveService.put(_boxName, _dataKey, data);
    } catch (e) {
      print('Error caching {{featureName.snakeCase()}} items: $e');
    }
  }

  @override
  Future<List<{{featureName.pascalCase()}}Model>> getCachedItems() async {
    try {
      final cachedData = await _hiveService.get(_boxName, _dataKey);
      if (cachedData != null) {
        return (cachedData as List)
            .map((item) => {{featureName.pascalCase()}}Model.fromJson(item))
            .toList();
      }
      return <{{featureName.pascalCase()}}Model>[];
    } catch (e) {
      print('Error getting cached {{featureName.snakeCase()}} items: $e');
      return <{{featureName.pascalCase()}}Model>[];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _hiveService.delete(_boxName, _dataKey);
    } catch (e) {
      print('Error clearing {{featureName.snakeCase()}} cache: $e');
    }
  }

  @override
  Future<void> logCache() async {
    await _hiveService.logBoxData(_boxName);
  }
}


