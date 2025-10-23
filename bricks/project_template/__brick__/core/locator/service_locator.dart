import 'package:get_it/get_it.dart';
import '../network/dio_consumer.dart';
import '../network/network_config.dart';
import '../network/api_consumer.dart';
import '../cache/hive_service.dart';
import '../cache/init_hive.dart';

// Import feature DI setups
import '../../features/auth/di/auth_di.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Service locator setup class
class ServiceLocator {
  /// Initialize all core services
  static Future<void> init() async {
    // Initialize Hive first
    await HiveInit.init();

    // Register core services
    sl.registerLazySingleton<HiveService>(() => HiveService());

    // Register network services
    sl.registerLazySingleton<NetworkConfig>(
      () => NetworkConfig.development, // Change to .production for production
    );

    sl.registerLazySingleton<DioConsumer>(
      () => DioConsumer(config: sl<NetworkConfig>()),
    );

    sl.registerLazySingleton<ApiConsumer>(() => sl<DioConsumer>());

    // Register feature services
    AuthDI.setup();

    // Add more features here as needed
  }
}
