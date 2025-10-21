import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  final Map<String, Future<Box>> _openingBoxes = {};

  static Future<void> init() async {
    await Hive.initFlutter();

    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final hiveDir = Directory(dir.path);
      if (await hiveDir.exists()) {
        try {
          await Process.run('xattr', [
            '-w',
            'com.apple.MobileBackup',
            '1',
            hiveDir.path,
          ]);
        } catch (e) {}
      }
    }
  }

  Future<Box> openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    if (_openingBoxes.containsKey(boxName)) {
      return _openingBoxes[boxName]!;
    }
    final future = Hive.openBox(boxName);
    _openingBoxes[boxName] = future;
    final box = await future;
    _openingBoxes.remove(boxName);
    return box;
  }

  Future<void> put(String boxName, String key, dynamic value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  Future<dynamic> get(String boxName, String key) async {
    final box = await openBox(boxName);
    return box.get(key);
  }

  Future<void> delete(String boxName, String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  Future<void> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.close();
      }
    } catch (e) {
      print('Hive closeBox error: $e');
    }
  }

  Future<void> logBoxKeys(String boxName) async {
    final box = await openBox(boxName);
    print('Hive box [$boxName] keys:');
    for (var key in box.keys) {
      print(' - $key');
    }
  }

  Future<void> logBoxData(String boxName) async {
    final box = await openBox(boxName);
    print('Hive box [$boxName] data:');
    for (var key in box.keys) {
      print(' - $key: ${box.get(key)}');
    }
  }
}
