/// Network configuration for the application
class NetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;
  final bool enableRetry;
  final int maxRetries;
  final Duration retryDelay;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.enableLogging = true,
    this.enableRetry = true,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  /// Development configuration
  static const NetworkConfig development = NetworkConfig(
    baseUrl: 'https://api-dev.example.com',
    enableLogging: true,
    enableRetry: true,
  );

  /// Production configuration
  static const NetworkConfig production = NetworkConfig(
    baseUrl: 'https://api.example.com',
    enableLogging: false,
    enableRetry: true,
    maxRetries: 2,
  );

  /// Testing configuration
  static const NetworkConfig testing = NetworkConfig(
    baseUrl: 'https://api-test.example.com',
    enableLogging: false,
    enableRetry: false,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  );

  /// Copy with method for customization
  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, String>? defaultHeaders,
    bool? enableLogging,
    bool? enableRetry,
    int? maxRetries,
    Duration? retryDelay,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      enableLogging: enableLogging ?? this.enableLogging,
      enableRetry: enableRetry ?? this.enableRetry,
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
    );
  }
}
