import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Custom interceptor for handling authentication and common headers
class AuthInterceptor extends Interceptor {
  final String Function()? getToken;
  final String Function()? getLanguage;
  final VoidCallback? onUnauthorized;

  AuthInterceptor({
    this.getToken,
    this.getLanguage,
    this.onUnauthorized,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication token
    final token = getToken?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add language header
    final language = getLanguage?.call();
    if (language != null && language.isNotEmpty) {
      options.headers['lang'] = language;
    }

    // Add default headers
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': _getContentType(options),
    });

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle 302 redirects as successful responses
    if (response.statusCode == 302) {
      response.statusCode = 200;
      if (kDebugMode) {
        print("Redirected response: ${response.data}");
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle unauthorized errors
    if (err.response?.statusCode == 401 || 
        err.response?.data?.toString().toLowerCase().contains('unauthenticated') == true) {
      onUnauthorized?.call();
    }
    
    super.onError(err, handler);
  }

  String _getContentType(RequestOptions options) {
    if (options.data is FormData) {
      return 'multipart/form-data';
    }
    return 'application/json';
  }
}

/// Interceptor for retry logic on failed requests
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [500, 502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    final requestOptions = err.requestOptions;
    
    if (shouldRetry && _getRetryCount(requestOptions) < maxRetries) {
      _incrementRetryCount(requestOptions);
      
      if (kDebugMode) {
        print('Retrying request: ${requestOptions.path} (${_getRetryCount(requestOptions)}/$maxRetries)');
      }
      
      await Future.delayed(retryDelay);
      
      try {
        final dio = Dio();
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } catch (e) {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response != null && retryStatusCodes.contains(err.response!.statusCode));
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retryCount'] as int? ?? 0;
  }

  void _incrementRetryCount(RequestOptions options) {
    options.extra['retryCount'] = _getRetryCount(options) + 1;
  }
}

/// Interceptor for caching responses
class CacheInterceptor extends Interceptor {
  final Map<String, CacheEntry> _cache = {};
  final Duration defaultCacheDuration;

  CacheInterceptor({
    this.defaultCacheDuration = const Duration(minutes: 5),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'GET') {
      final cacheKey = _generateCacheKey(options);
      final cacheEntry = _cache[cacheKey];
      
      if (cacheEntry != null && !cacheEntry.isExpired) {
        if (kDebugMode) {
          print('Cache hit for: ${options.path}');
        }
        handler.resolve(cacheEntry.response);
        return;
      }
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET' && 
        response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      final cacheDuration = _getCacheDuration(response.requestOptions);
      
      _cache[cacheKey] = CacheEntry(
        response: response,
        expiry: DateTime.now().add(cacheDuration),
      );
      
      if (kDebugMode) {
        print('Cached response for: ${response.requestOptions.path}');
      }
    }
    
    super.onResponse(response, handler);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = Uri(
      path: options.path,
      queryParameters: options.queryParameters.isNotEmpty 
          ? options.queryParameters.map((key, value) => MapEntry(key, value.toString()))
          : null,
    );
    return uri.toString();
  }

  Duration _getCacheDuration(RequestOptions options) {
    final customDuration = options.extra['cacheDuration'] as Duration?;
    return customDuration ?? defaultCacheDuration;
  }

  void clearCache() {
    _cache.clear();
  }

  void removeCacheEntry(String key) {
    _cache.remove(key);
  }
}

class CacheEntry {
  final Response response;
  final DateTime expiry;

  CacheEntry({required this.response, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

/// Interceptor for comprehensive logging
class EnhancedLoggerInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final bool logHeaders;
  final bool logBody;

  EnhancedLoggerInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logHeaders = false,
    this.logBody = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest && kDebugMode) {
      log('🚀 REQUEST[${options.method}] => PATH: ${options.path}', name: 'DIO');
      
      if (logHeaders && options.headers.isNotEmpty) {
        log('Headers: ${options.headers}', name: 'DIO');
      }
      
      if (logBody && options.data != null) {
        log('Body: ${options.data}', name: 'DIO');
      }
      
      if (options.queryParameters.isNotEmpty) {
        log('Query Parameters: ${options.queryParameters}', name: 'DIO');
      }
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse && kDebugMode) {
      log('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}', name: 'DIO');
      
      if (logHeaders && response.headers.map.isNotEmpty) {
        log('Headers: ${response.headers.map}', name: 'DIO');
      }
      
      if (logBody && response.data != null) {
        log('Body: ${response.data}', name: 'DIO');
      }
    }
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError && kDebugMode) {
      log('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}', name: 'DIO');
      log('Error Type: ${err.type}', name: 'DIO');
      log('Error Message: ${err.message}', name: 'DIO');
      
      if (err.response != null && logBody) {
        log('Error Response: ${err.response?.data}', name: 'DIO');
      }
    }
    
    super.onError(err, handler);
  }
}

