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
flutter_localizations:
  sdk: flutter
intl: ^0.20.0

dio: ^5.8.0+1
cached_network_image: ^3.2.3
shimmer: ^3.0.0
flutter_svg: ^2.0.7
smooth_page_indicator: ^1.1.0
bloc: ^8.1.2
flutter_bloc: ^8.1.3
carousel_slider: ^4.2.1
animated_widgets_flutter: ^1.1.1+2
get_it: ^7.6.0
lottie: ^2.0.1
responsive_framework: ^1.5.1
fluttertoast: ^8.1.2
hive: ^2.2.3
hive_flutter: ^1.1.0
flutter_smart_dialog: ^4.9.8+9
bot_toast: ^4.1.3
pretty_dio_logger: ^1.4.0
permission_handler: ^12.0.1
image_picker: ^1.1.2
device_info_plus: ^11.5.0
dotted_border: ^3.1.0
pinput: ^5.0.1
animate_do: ^3.3.2
chewie: ^1.12.1
flutter_secure_storage: ^9.2.4
video_player: ^2.10.0
file_picker: ^10.2.0

geolocator: ^14.0.2
geocoding: ^4.0.0
google_maps_flutter: ^2.12.3
infinite_scroll_pagination:
  ^4.1.0
  # url_launcher: ^6.2.4
# whatsapp: ^2.0.0

# Use this line for build with obfuscate app

# flutter clean && flutter pub get && flutter build ipa --dart-define-from-file=env.json --obfuscate --split-debug-info=build/app/outputs/symbols
```

### generate assets folder:

```shell
mason make assets -o ../
```

## generate project template:

```shell
mason make project_template -o .././lib
```

## add new feature with the name you give:

```shell
mason make feature -o .././lib/features
```

## add the default authentications and splash:

```shell
mason make auth -o .././lib/features
```

## add the default static pages:

```shell
mason make static_pages -o .././lib/features
```

## add the webview_payment:

```shell
mason make webview_payment -o .././lib/shared/widgets
```

## Add assets paths in pubspec.yaml file

```
  assets:
    - assets/images/
    - assets/json/
    - assets/fonts/
    - assets/icons/
    - assets/translations/

```

## generate file that contains assets variables and fonts and json:

1. generate app assets add to yaml

```shell
flutter_assets:
  assets_path: assets/
  output_path: lib/core/constants/
  filename: app_assets.dart
  field_prefix:
  classname: AppAssets
  assets_path:
    - assets/images/
    - assets/icons/

```

1. generate app localization

````shell
flutter gen-l10n```


2. add these dependencies to dev_dependencies

```yaml
dev_dependencies:
  build_runner:
  flutter_gen_runner:
  injectable_generator:
````

3. add flutter gen configs to pubspec.yaml

```yaml
flutter_gen:
  output: lib/core/resources/gen/
  line_length: 80

  # Optional
  integrations:
    flutter_svg: true
    flare_flutter: true
    rive: true
    lottie: true
```

generate assets folder:

dart run build_runner build

mason make assets -o ../

mason make project_template -o .././lib

dart pub run easy_localization:generate -S "assets/translations" -O "lib/core/app_strings" -o "locale_keys.dart" -f keys

mason make auth -o .././lib/features

mason make feature -o .././lib/features
