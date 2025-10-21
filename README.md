## Introduction

the easiest way you can add a template for your project
you can customize the template as you wish
here we start by

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
```

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

### 3. Complete Setup

```shell
# Get dependencies
mason get

# Generate all components
mason make assets -o ../
mason make project_template -o .././lib
mason make auth -o .././lib/features
```
