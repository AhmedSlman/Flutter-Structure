import 'service_locator.dart';

/// Easy setup function for service locator
/// Call this in main.dart before running the app
Future<void> setupLocator() async {
  await ServiceLocator.init();
}

/// Quick access to service locator
/// Use this instead of importing GetIt directly
final locator = ServiceLocator;
