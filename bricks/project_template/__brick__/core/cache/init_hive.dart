import 'hive_service.dart';

/// Initialize Hive for the entire app
/// Call this in main.dart before running the app
class HiveInit {
  static Future<void> init() async {
    await HiveService.init();
  }
}
