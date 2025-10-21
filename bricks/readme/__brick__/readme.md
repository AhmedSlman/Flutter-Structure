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
## if you are using macos you must add SSH  to your device 

```shell
ssh-keygen
```

```shell
cat ~/.ssh/id_rsa.pub
```

```shell
cd ~/.ssh
```
```shell
ssh-keygen -R github.com
```
```shell
ssh -T git@github.com
```
this will allow tou to access the github in your macos so you can use the mason properlay  

## generate file to macos that contains assets variables and widgets and feature: 

add bricks to mason.yaml file so you can access the files that I have share on Github


```shell
bricks:
    readme:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/readme
    assets:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/assets
    project_template:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/project_template
    feature:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/feature
    auth:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/auth
    webview_payment:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/webview_payment
    static_pages:
      git:
        url: git@github.com:YoussefAbdelmonem/mason-updates.git
        path: bricks/static_pages

```



## for the public repo we use this 
## generate file that contains assets variables and widgets and feature: 

add bricks to mason.yaml file so you can access the files that I have share on Github


```shell
bricks:
    readme:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/readme
    assets:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/assets
    project_template:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/project_template
    feature:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/feature
    auth:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/auth
    webview_payment:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/webview_payment 
    static_pages:
      git:
        url: https://github.com/YoussefAbdelmonem/mason-updates
        path: bricks/static_pages

```

## to get the dependecy that you applied

```shell
mason get
```
## Dependencies

Below is a list of default dependencies used in this project:
```yaml
  dio: ^5.2.0
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  flutter_svg: ^2.0.7
  smooth_page_indicator: ^1.1.0
  bloc: ^8.1.2
  flutter_bloc: ^8.1.3
  carousel_slider: ^4.2.1
  animated_widgets_flutter: ^1.1.1+2
  get_it: ^7.6.0
  lottie: ^1.3.0
  fluttertoast: ^8.1.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_smart_dialog: ^4.8.2
  sc: ^1.1.0
  bot_toast: ^4.0.3
  flutter_screenutil:
  pretty_dio_logger:
  permission_handler:
  image_picker:
  device_info_plus:
  dotted_border:
  pinput:
  animate_do:

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

1. activate flutter gen 

```shell
dart pub global activate flutter_gen
```

1. generate app localization

```shell
dart pub run easy_localization:generate -S "assets/translations" -O "lib/core/app_strings" -o "locale_keys.dart" -f keys  
```


2. add these dependencies to dev_dependencies  

```yaml
dev_dependencies:
  build_runner:
  flutter_gen_runner:
  injectable_generator: 
```

3. add flutter gen configs to pubspec.yaml

```yaml
flutter_gen:
  output: lib/core/resources/
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
