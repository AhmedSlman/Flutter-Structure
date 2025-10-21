/// Configuration class for network settings
class NetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration? sendTimeout;
  final bool enableLogging;
  final bool enableRetry;
  final bool enableCache;
  final int maxRetries;
  final Duration retryDelay;
  final Duration cacheDuration;
  final Map<String, String> defaultHeaders;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout,
    this.enableLogging = true,
    this.enableRetry = true,
    this.enableCache = false,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.cacheDuration = const Duration(minutes: 5),
    this.defaultHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  });

  /// Development configuration
  static const NetworkConfig development = NetworkConfig(
    baseUrl: 'https://api-dev.example.com',
    enableLogging: true,
    enableRetry: true,
    enableCache: false,
  );

  /// Production configuration
  static const NetworkConfig production = NetworkConfig(
    baseUrl: 'https://api.example.com',
    enableLogging: false,
    enableRetry: true,
    enableCache: true,
  );

  /// Testing configuration
  static const NetworkConfig testing = NetworkConfig(
    baseUrl: 'https://api-test.example.com',
    enableLogging: false,
    enableRetry: false,
    enableCache: false,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  );
}

/// Request configuration for individual API calls
class RequestConfig {
  final bool loading;
  final bool isForm;
  final bool isFile;
  final bool enableRetry;
  final bool enableCache;
  final Duration? cacheDuration;
  final int? maxRetries;
  final Map<String, String>? customHeaders;

  const RequestConfig({
    this.loading = false,
    this.isForm = false,
    this.isFile = false,
    this.enableRetry = true,
    this.enableCache = false,
    this.cacheDuration,
    this.maxRetries,
    this.customHeaders,
  });

  /// Default configuration for GET requests
  static const RequestConfig get = RequestConfig(
    enableCache: true,
  );

  /// Default configuration for POST requests
  static const RequestConfig post = RequestConfig(
    loading: true,
  );

  /// Default configuration for form submissions
  static const RequestConfig form = RequestConfig(
    loading: true,
    isForm: true,
  );

  /// Default configuration for file uploads
  static const RequestConfig fileUpload = RequestConfig(
    loading: true,
    isFile: true,
    enableRetry: false,
  );
}
