## Introduction

the easiest way you can add a template for your project
you can customize the template as you wish
here we start by

## Project Structure

### Features Structure

Each feature follows Clean Architecture pattern:

```
features/
├── {{feature_name}}/
│   ├── data/
│   │   ├── data_source/
│   │   │   ├── local/
│   │   │   │   └── local_data_source.dart
│   │   │   └── remote/
│   │   │       └── remote_data_source.dart
│   │   ├── models/
│   │   │   ├── request/
│   │   │   │   └── {{feature_name}}_request.dart
│   │   │   └── response/
│   │   │       └── {{feature_name}}_model.dart
│   │   └── repository/
│   │       ├── {{feature_name}}_repository_impl.dart
│   │       ├── {{feature_name}}_repository.dart
│   │       └── endpoints.dart
│   ├── di/
│   │   └── {{feature_name}}_di.dart
│   ├── logic/
│   │   ├── {{feature_name}}_cubit.dart
│   │   └── {{feature_name}}_states.dart
│   ├── presentation/
│   │   ├── components/
│   │   │   └── {{feature_name}}_components.dart
│   │   ├── views/
│   │   │   └── {{feature_name}}_view.dart
│   │   └── widgets/
│   │       ├── {{feature_name}}_widgets.dart
│   │       └── widgets.dart
│   └── router/
│       ├── {{feature_name}}_names.dart
│       └── {{feature_name}}_router.dart
```

### Feature Components Description

#### 📊 **data/**

- `data_source/` - Data sources (local & remote)
- `models/` - Data models (request & response)
- `repository/` - Repository implementation

#### 🔗 **di/**

- `{{feature_name}}_di.dart` - Dependency injection setup

#### 🧠 **logic/**

- `{{feature_name}}_cubit.dart` - Business logic (Cubit)
- `{{feature_name}}_states.dart` - State classes

#### 🎨 **presentation/**

- `components/` - UI components
- `views/` - Screen views
- `widgets/` - Reusable widgets

#### 🧭 **router/**

- `{{feature_name}}_names.dart` - Route names
- `{{feature_name}}_router.dart` - Route configuration

### Core Structure

The core folder contains shared utilities and configurations:

```
core/
├── app_strings/
│   ├── app_strings.dart
│   └── locale_keys.dart
├── cache/
│   ├── cache_helper.dart
│   ├── hive_service.dart
│   ├── init_hive.dart
│   └── secure_storage.dart
├── config/
│   ├── config.dart
│   └── key.dart
├── error/
│   ├── error_handler.dart
│   ├── exceptions.dart
│   ├── failures.dart
│   └── result_extensions.dart
├── extensions/
│   ├── all_extensions.dart
│   ├── context_extensions.dart
│   ├── date_time_extensions.dart
│   ├── double_extensions.dart
│   ├── int_extensions.dart
│   ├── string_extensions.dart
│   ├── text_style_extensions.dart
│   └── widget_extensions.dart
├── general/
│   ├── general_cubit.dart
│   ├── general_state.dart
│   └── my_bloc_observer.dart
├── localization/
│   └── localization_helper.dart
├── locator/
│   ├── locator_setup.dart
│   └── service_locator.dart
├── network/
│   ├── api_consumer.dart
│   ├── dio_consumer.dart
│   ├── interceptors/
│   │   ├── auth_interceptor.dart
│   │   └── retry_interceptor.dart
│   ├── network_config.dart
│   └── retry_interceptor.dart
├── Router/
│   ├── app_router.dart
│   └── router_names.dart
├── services/
│   ├── alerts.dart
│   └── media/
│       ├── alert_of_media.dart
│       ├── item_of_contact.dart
│       └── media_service.dart
├── theme/
│   ├── app_colors.dart
│   ├── app_typography.dart
│   └── theme_manager.dart
└── utils/
    ├── app_assets.dart
    ├── extentions.dart
    ├── firebase_message.dart
    ├── general_constants.dart
    ├── index.dart
    ├── regx.dart
    ├── utils.dart
    └── validations.dart
```

### Core Components Description

#### 📱 **app_strings/**

- `app_strings.dart` - Static strings for the app
- `locale_keys.dart` - Generated localization keys

#### 💾 **cache/**

- `cache_helper.dart` - Cache management utilities
- `hive_service.dart` - Hive database service
- `init_hive.dart` - Hive initialization
- `secure_storage.dart` - Secure storage for sensitive data

#### ⚙️ **config/**

- `config.dart` - App configuration settings
- `key.dart` - API keys and secrets

#### ❌ **error/**

- `error_handler.dart` - Global error handling
- `exceptions.dart` - Custom exceptions
- `failures.dart` - Failure classes
- `result_extensions.dart` - Result extensions

#### 🔧 **extensions/**

- `all_extensions.dart` - All extensions export
- `context_extensions.dart` - BuildContext extensions
- `date_time_extensions.dart` - DateTime utilities
- `double_extensions.dart` - Double utilities
- `int_extensions.dart` - Integer utilities
- `string_extensions.dart` - String utilities
- `text_style_extensions.dart` - TextStyle utilities
- `widget_extensions.dart` - Widget utilities

#### 🌐 **general/**

- `general_cubit.dart` - Global state management
- `general_state.dart` - Global states
- `my_bloc_observer.dart` - Bloc observer

#### 🌍 **localization/**

- `localization_helper.dart` - Localization utilities

#### 🔗 **locator/**

- `locator_setup.dart` - Dependency injection setup
- `service_locator.dart` - Service locator

#### 🌐 **network/**

- `api_consumer.dart` - API consumer interface
- `dio_consumer.dart` - Dio implementation
- `interceptors/` - Network interceptors
- `network_config.dart` - Network configuration

#### 🧭 **Router/**

- `app_router.dart` - Main app router
- `router_names.dart` - Route names

#### 🛠️ **services/**

- `alerts.dart` - Alert dialogs
- `media/` - Media handling services

#### 🎨 **theme/**

- `app_colors.dart` - App color scheme
- `app_typography.dart` - Typography settings
- `theme_manager.dart` - Theme management

#### 🔧 **utils/**

- `app_assets.dart` - Asset paths
- `extentions.dart` - General extensions
- `firebase_message.dart` - Firebase messaging
- `general_constants.dart` - App constants
- `index.dart` - Exports
- `regx.dart` - Regular expressions
- `utils.dart` - General utilities
- `validations.dart` - Input validations

## Getting Started

1. Install Mason

```shell
dart pub global activate mason_cli

```

2. Add mason to your project

```shell
mkdir mason && cd mason && mason init
```

## for the public repo we use this

## generate file that contains assets variables and widgets and feature:

add bricks to mason.yaml file so you can access the files that I have share on github

```shell
bricks:
    readme:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/readme
        ref: main
    assets:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/assets
        ref: main
    project_template:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/project_template
        ref: main
    feature:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/feature
        ref: main
    auth:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/auth
        ref: main
    webview_payment:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/webview_payment
        ref: main
    static_pages:
      git:
        url: https://github.com/AhmedSlman/Flutter-Structure
        path: bricks/static_pages
        ref: main


```

## to get the dependecy that you applied

```shell
mason get
```

## Dependencies

Below is a list of default dependencies used in this project:

### Core Dependencies

```yaml
# State Management
flutter_bloc: ^8.1.3
bloc: ^8.1.2

# Localization
easy_localization: ^3.0.4

# Navigation
go_router: ^12.1.3

# Network
dio: ^5.4.0
connectivity_plus: ^5.0.2

# Storage
shared_preferences: ^2.2.2
hive: ^2.2.3
hive_flutter: ^1.1.0
flutter_secure_storage: ^9.0.0

# UI
flutter_screenutil: ^5.9.0
responsive_framework: ^1.1.1
flutter_smart_dialog: ^3.3.0
bot_toast: ^4.0.1
flutter_svg: ^2.0.9

# Utils
get_it: ^7.6.4
equatable: ^2.0.5
json_annotation: ^4.8.1
intl: ^0.19.0

# Media
image_picker: ^1.0.4
permission_handler: ^11.1.0

# Maps & Location
google_maps_flutter: ^2.5.3
geolocator: ^10.1.0
geocoding: ^2.1.1

# Firebase
firebase_core: ^2.24.2
firebase_messaging: ^14.7.10

# Video & Audio
agora_rtc_engine: ^6.3.0
pusher_channels_flutter: ^2.2.1
video_player: ^2.8.2
chewie: ^1.7.4

# Additional UI Packages
carousel_slider: ^4.2.1
shimmer: ^3.0.0
lottie: ^2.7.0
cached_network_image: ^3.3.0
infinite_scroll_pagination: ^4.0.0
dotted_border: ^2.1.0
flutter_map: ^6.1.0
latlong2: ^0.8.1
file_picker: ^6.1.1
path_provider: ^2.1.1
pretty_dio_logger: ^1.3.1
dartz: ^0.10.1
```

### Package Descriptions

#### 🎥 **Video & Audio Packages**
- `video_player: ^2.8.2` - Video playback functionality
- `chewie: ^1.7.4` - Video player controls and UI

#### 🎨 **UI Enhancement Packages**
- `carousel_slider: ^4.2.1` - Carousel/slider widgets
- `shimmer: ^3.0.0` - Loading shimmer effects
- `lottie: ^2.7.0` - Lottie animations
- `cached_network_image: ^3.3.0` - Cached network images
- `infinite_scroll_pagination: ^4.0.0` - Infinite scroll pagination
- `dotted_border: ^2.1.0` - Dotted border widgets

#### 🗺️ **Maps & Location Packages**
- `flutter_map: ^6.1.0` - Alternative map implementation
- `latlong2: ^0.8.1` - Latitude/longitude utilities

#### 📁 **File & Media Packages**
- `file_picker: ^6.1.1` - File selection functionality
- `path_provider: ^2.1.1` - File system paths

#### 🌐 **Network & Logging Packages**
- `pretty_dio_logger: ^1.3.1` - Network request logging
- `dartz: ^0.10.1` - Functional programming utilities

## Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

  # Code Generation
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
```

## Generate Project Components

### Generate Assets Folder

```shell
mason make assets -o ../
```

### Generate Project Template

```shell
mason make project_template -o .././lib
```

### Add New Feature

```shell
mason make feature -o .././lib/features
```

### Add Authentication & Splash

```shell
mason make auth -o .././lib/features
```

### Add Static Pages

```shell
mason make static_pages -o .././lib/features
```

### Add WebView Payment

```shell
mason make webview_payment -o .././lib/shared/widgets
```

## Add Assets Paths in pubspec.yaml

```yaml
flutter:
  assets:
    - assets/translations/
    - assets/images/
    - assets/icons/
    - assets/fonts/
```

## Recent Updates & Improvements

### 🎨 **UI/UX Enhancements**
- **AppColors Integration**: All widgets now use centralized color system
- **AppStyles Integration**: Consistent typography across all components
- **Easy Localization**: Full translation support with `.tr()` method
- **GoRouter Navigation**: Modern navigation system replacing NavigationService

### 📦 **New Packages Added**
- **Video Support**: `video_player` + `chewie` for media playback
- **Loading States**: `shimmer` for skeleton loading effects
- **Animations**: `lottie` for smooth animations
- **Image Caching**: `cached_network_image` for optimized image loading
- **Pagination**: `infinite_scroll_pagination` for large data sets
- **File Handling**: `file_picker` for file selection
- **Network Logging**: `pretty_dio_logger` for debugging API calls

### 🔧 **Code Quality Improvements**
- **Consistent Theming**: All widgets use `AppColors` and `AppStyles`
- **Localization Ready**: All text strings support translation
- **Modern Navigation**: GoRouter implementation
- **Error Handling**: Improved error messages with localization
- **Performance**: Optimized widget rendering and memory usage

### 📱 **Widget Updates**
- **24 Shared Widgets** updated with new theming system
- **15+ Core Files** enhanced with localization support
- **All Extensions** now support `AppColors` and `AppStyles`
- **Network Layer** updated for better error handling

## Setup Localization

### 1. Configure Easy Localization

Add easy_localization configuration to your `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}
```

### 2. Generate Translation Keys

```shell
dart pub run easy_localization:generate -S "assets/translations" -O "lib/core/app_strings" -o "locale_keys.dart" -f keys
```

### 3. Translation Keys Required

Add these keys to your translation files (`assets/translations/en.json` and `assets/translations/ar.json`):

```json
{
  "data_error": "An error occurred",
  "retry": "Retry",
  "go_back": "Go Back",
  "no_items": "No items found",
  "search": "Search",
  "ok": "OK",
  "please_choose": "Please choose",
  "pick_location": "Pick Location",
  "error": "Error",
  "page_not_found": "Page Not Found",
  "back_to_home": "Back to Home"
}
```

### 4. Complete Setup

```shell
# Get dependencies
mason get

# Generate all components
mason make assets -o ../
mason make project_template -o .././lib
mason make auth -o .././lib/features
```

## Benefits of the Updated Template

### 🚀 **Performance Benefits**
- **Optimized Rendering**: All widgets use efficient rendering patterns
- **Memory Management**: Better memory usage with cached images and optimized state management
- **Network Efficiency**: Improved API calls with proper error handling and logging

### 🎨 **Design Benefits**
- **Consistent UI**: Unified color scheme and typography across all components
- **Responsive Design**: All widgets adapt to different screen sizes
- **Modern Animations**: Smooth Lottie animations and shimmer effects
- **Accessibility**: Better accessibility support with proper semantic widgets

### 🌍 **Localization Benefits**
- **Multi-language Support**: Easy translation with `.tr()` method
- **RTL Support**: Full right-to-left language support
- **Dynamic Language Switching**: Change language without app restart
- **Fallback Handling**: Graceful fallback for missing translations

### 🔧 **Development Benefits**
- **Code Reusability**: Highly reusable widgets with consistent API
- **Type Safety**: Strong typing with proper null safety
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Debugging**: Enhanced debugging with network logging and error tracking

### 📱 **User Experience Benefits**
- **Smooth Navigation**: Modern GoRouter navigation with proper back stack
- **Loading States**: Beautiful loading animations and skeleton screens
- **Error Recovery**: User-friendly error messages with retry options
- **Offline Support**: Proper offline handling with cached data
