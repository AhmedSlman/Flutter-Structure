# 📦 Chat Brick Dependencies | متطلبات Brick الشات

## 🔴 Required Project Structure | الهيكل المطلوب في المشروع

This chat brick expects your Flutter project to have the following structure from the `project_template` brick:

```
lib/
├── core/
│   ├── data_source/
│   │   ├── dio_helper.dart          # Required - HTTP client wrapper
│   │   └── hive_helper.dart         # Required - Local storage
│   ├── Router/
│   │   └── Router.dart              # Required - Navigation routes
│   ├── utils/
│   │   ├── Locator.dart             # Required - DI setup
│   │   ├── utils.dart               # Required - Utils class
│   │   └── extentions.dart          # Required - Extensions
│   ├── extensions/
│   │   └── all_extensions.dart      # Required - Context extensions
│   └── app_strings/
│       └── locale_keys.dart         # Required - Translation keys
└── shared/
    └── widgets/
        ├── network_image.dart       # Required
        ├── empty_widget.dart        # Required
        ├── colored_container.dart   # Required
        ├── two_tile_app_bar.dart   # Required
        └── default_image_widget.dart # Required
```

## 📦 Required Packages | الحزم المطلوبة

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Networking
  dio: ^5.8.0+1
  pretty_dio_logger: ^1.4.0

  # State Management
  bloc: ^8.1.2
  flutter_bloc: ^8.1.3

  # Real-time Communication
  pusher_channels_flutter: ^2.2.1

  # Video Calls
  agora_uikit:
    git:
      url: https://github.com/eng-sayed/VideoUIKit-Flutter-min-SDK-21.git
      ref: test

  # UI Components
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  flutter_svg: ^2.0.7
  gap: ^3.0.1
  emoji_picker_flutter: ^3.1.0
  photo_view: ^0.15.0
  flutter_widget_from_html: ^0.16.0

  # Pagination
  infinite_scroll_pagination: ^4.1.0
  flutter_slidable: ^4.0.0

  # Voice Recording & Playing
  record: ^6.0.0
  audioplayers: ^6.1.0
  permission_handler:
  path_provider: ^2.1.4

  # File Handling
  file_picker: ^10.1.9
  image_picker:

  # Location & Maps
  google_maps_flutter: ^2.12.1
  geolocator: ^14.0.0
  geocoding: ^3.0.0
  url_launcher: ^6.3.1
  widget_to_marker: ^1.0.6

  # Localization
  easy_localization: ^3.0.2

  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Firebase
  firebase_core:
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^19.3.0

  # Utils
  get_it: ^7.6.0
  lottie: ^1.3.0
  fluttertoast: ^8.1.2
  flutter_smart_dialog: ^4.8.2
  bot_toast: ^4.0.3
  linkfy_text: ^1.1.6
  cupertino_icons: ^1.0.8
  device_info_plus:
  video_player: ^2.9.5
  flutter_pdfview: ^1.4.1+1
  open_filex: ^4.7.0
  share_plus: ^11.0.0

  # Device
  device_uuid:
    git:
      url: https://github.com/abdoshamss/device_uuid
      ref: fix
```

## ⚙️ Required Setup | الإعدادات المطلوبة

### 1. Generate project_template first

```bash
mason make project_template -o ./lib
```

### 2. Then generate chat brick

```bash
mason make chat -o ./lib/features
```

### 3. The hooks will automatically:

- Register repositories in `Locator.dart`
- Add routes to `Router.dart`

## 📱 Platform Setup Required | إعدادات المنصات المطلوبة

### Android - `android/app/src/main/AndroidManifest.xml`

```xml
<!-- Permissions -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<!-- Google Maps API Key -->
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_KEY"/>
</application>
```

### iOS - `ios/Runner/Info.plist`

```xml
<!-- Permission Descriptions -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to send photos in chat</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice messages and video calls</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to share your location in chat</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to send images in chat</string>

<!-- Google Maps API Key -->
<key>GMSApiKey</key>
<string>YOUR_GOOGLE_MAPS_KEY</string>
```

### Firebase Setup

1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`
3. Run: `flutterfire configure`

## 🔧 Post-Generation Steps | الخطوات بعد التوليد

1. **Update `lib/core/utils/utils.dart`** - Ensure you have:

   ```dart
   static String token = '';
   static UserModel userModel = UserModel();
   static String currentRoomId = '';
   ```

2. **Update `lib/core/config/key.dart`** - Add your base URL:

   ```dart
   class ConstKeys {
     static const String baseUrl = 'YOUR_API_URL/api/';
   }
   ```

3. **Run**:
   ```bash
   flutter pub get
   flutter run
   ```

## 📚 Related Bricks | Bricks ذات صلة

Make sure you've generated these bricks first:

- ✅ `assets` - For assets structure
- ✅ `project_template` - For core structure
- ✅ `auth` (optional) - For authentication

---

**Need help?** Check the main README.md for detailed usage instructions.
