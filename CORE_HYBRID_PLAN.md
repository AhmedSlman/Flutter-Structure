# Core Hybrid - Design Plan

## 🎯 الهدف

دمج أفضل ميزات `core` الحالي مع `core_new` لإنشاء بنية hybrid مثالية.

## 📦 البنية المقترحة

```
core/
├── error/                    # ✨ من core_new
│   ├── failures.dart        # Failure Pattern
│   ├── exceptions.dart      # Custom exceptions
│   └── error_handler.dart   # Error handling utilities
│
├── network/                 # ✨ من core_new (محسّن)
│   ├── api/
│   │   ├── api_consumer.dart      # Abstract interface
│   │   └── dio_consumer.dart      # Dio implementation
│   ├── interceptors/
│   │   ├── auth_interceptor.dart
│   │   ├── logging_interceptor.dart
│   │   └── retry_interceptor.dart
│   ├── models/
│   │   └── api_response.dart
│   └── network_config.dart
│
├── cache/                   # ✨ من core_new (محسّن)
│   ├── cache_helper.dart
│   ├── hive_service.dart
│   └── secure_storage.dart
│
├── di/                      # ✨ من core_new (مع Mason support)
│   └── injection.dart       # GetIt setup
│
├── router/                  # ✅ من core (GoRouter)
│   ├── app_router.dart
│   ├── route_names.dart
│   └── navigation_service.dart
│
├── resources/              # ✨ من core_new
│   ├── app_colors.dart
│   ├── app_assets.dart
│   ├── app_strings.dart
│   └── app_theme.dart
│
├── extensions/             # ✅ من core (موجود)
│   ├── context_extensions.dart
│   ├── string_extensions.dart
│   └── widget_extensions.dart
│
├── utils/                  # ✅ من core + تحسينات
│   ├── validators.dart
│   ├── constants.dart
│   └── helpers.dart
│
└── localization/          # ✅ من core
    ├── generated/
    └── localization_helper.dart
```

## ✅ من core (الحالي)

### 1. GoRouter Implementation

```dart
✅ app_router.dart - Complete GoRouter setup
✅ navigation_service.dart - Helper methods
✅ route_names.dart - Route constants
```

### 2. Extensions

```dart
✅ context_extensions.dart
✅ string_extensions.dart
✅ widget_extensions.dart
✅ All other extensions
```

### 3. Localization

```dart
✅ LocalizationHelper
✅ Generated files
✅ ARB files
```

### 4. Mason Support

```dart
✅ Relative imports
✅ Mason variables ready
✅ Auto-generation hooks
```

## ✨ من core_new

### 1. Failure Pattern (Error Handling)

```dart
// failures.dart
abstract class Failure {
  final String message;
  final String? code;

  // Multiple failure types
  - ServerFailure
  - NetworkFailure
  - CacheFailure
  - ValidationFailure
  - AuthFailure
}

// Extensions
extension FailureExtensions on Failure {
  bool get isNetworkError => ...
  String get userMessage => ...
}
```

### 2. ApiConsumer Pattern

```dart
// api_consumer.dart
abstract class ApiConsumer {
  Future<T> get<T>(...);
  Future<T> post<T>(...);
  Future<T> put<T>(...);
  Future<T> delete<T>(...);
}

// dio_consumer.dart
class DioConsumer implements ApiConsumer {
  // Professional implementation
  // Interceptors
  // Error handling
}
```

### 3. Enhanced Caching

```dart
// cache_helper.dart - General caching
// hive_service.dart - Structured data
// secure_storage.dart - Sensitive data
```

### 4. Resources Management

```dart
// app_colors.dart - Centralized colors
// app_assets.dart - Assets management
// app_strings.dart - Strings constants
// app_theme.dart - Theme configuration
```

### 5. DI Organization

```dart
// injection.dart
final sl = GetIt.instance;

Future<void> setupDI() async {
  // Core services
  _registerCore();

  // Network
  _registerNetwork();

  // Cache
  _registerCache();

  // Features (via hooks)
  // Auto-generated
}
```

## 🔄 التحسينات

### 1. Error Handling

```dart
// Before (core):
try {
  final response = await dio.get(...);
} on DioException catch (e) {
  // Handle
}

// After (hybrid):
try {
  final result = await apiConsumer.get<User>(...);
  return result.fold(
    onSuccess: (data) => Right(data),
    onFailure: (failure) => Left(failure),
  );
} catch (e) {
  return Left(UnknownFailure());
}
```

### 2. Network Layer

```dart
// Before (core):
DioService(baseUrl)

// After (hybrid):
ApiConsumer apiConsumer = DioConsumer(
  dio: dio,
  config: NetworkConfig.production,
);
```

### 3. Caching

```dart
// Before (core):
HiveService only

// After (hybrid):
- CacheHelper - for general data
- HiveService - for structured data
- SecureStorage - for tokens/sensitive
```

## 📝 Implementation Steps

### Phase 1: Error Handling

- [ ] Create failures.dart
- [ ] Create exceptions.dart
- [ ] Create error_handler.dart
- [ ] Add extensions

### Phase 2: Network Layer

- [ ] Create api_consumer.dart (abstract)
- [ ] Create dio_consumer.dart (implementation)
- [ ] Migrate interceptors
- [ ] Add network_config.dart
- [ ] Create api_response.dart

### Phase 3: Caching

- [ ] Create cache_helper.dart
- [ ] Enhance hive_service.dart
- [ ] Create secure_storage.dart

### Phase 4: Resources

- [ ] Create app_colors.dart
- [ ] Create app_assets.dart
- [ ] Create app_strings.dart
- [ ] Create app_theme.dart

### Phase 5: DI

- [ ] Create injection.dart
- [ ] Setup core services
- [ ] Add Mason hooks support

### Phase 6: Integration

- [ ] Copy GoRouter from core
- [ ] Copy extensions from core
- [ ] Copy localization from core
- [ ] Update imports

### Phase 7: Testing

- [ ] Test error handling
- [ ] Test network layer
- [ ] Test caching
- [ ] Test DI
- [ ] Test Mason generation

## 🎯 النتيجة المتوقعة

### Features:

✅ Clean Architecture (from core_new)
✅ Failure Pattern (from core_new)
✅ ApiConsumer Pattern (from core_new)
✅ Multi-caching (from core_new)
✅ GoRouter (from core)
✅ Mason Support (from core)
✅ Simple Structure (from core)
✅ Scalable (from core_new)
✅ Easy to use (from core)
✅ Professional (from core_new)

### Score:

- Architecture: ⭐⭐⭐⭐⭐
- Code Quality: ⭐⭐⭐⭐⭐
- Mason Ready: ⭐⭐⭐⭐⭐
- Reusability: ⭐⭐⭐⭐⭐
- Simplicity: ⭐⭐⭐⭐⭐
- Scalability: ⭐⭐⭐⭐⭐

**Overall: 10/10** 🌟
