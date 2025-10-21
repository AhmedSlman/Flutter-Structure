# 📖 Chat Brick - Complete Usage Guide | دليل الاستخدام الكامل

---

## 📑 Table of Contents | جدول المحتويات

1. [Installation](#installation)
2. [Configuration](#configuration)
3. [API Integration](#api-integration)
4. [Usage Examples](#usage-examples)
5. [Customization](#customization)
6. [Advanced Features](#advanced-features)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## 1. Installation | التثبيت

### Step 1: Install Mason CLI

```bash
dart pub global activate mason_cli
```

### Step 2: Generate Project Template

```bash
# Navigate to your project root
cd your_flutter_project

# Create mason directory
mkdir mason && cd mason && mason init

# Generate project template first
cd ..
mason make project_template -o ./lib
```

### Step 3: Add Chat Brick

Add to `mason/mason.yaml`:

```yaml
bricks:
  chat:
    path: ../flutter-structure/bricks/chat
```

### Step 4: Get Bricks

```bash
cd mason
mason get
```

### Step 5: Generate Chat Module

```bash
cd ..
mason make chat -o ./lib/features
```

You'll be prompted for:

```
✔ What is your API base URL? · https://your-api.com/api/
✔ What is your Pusher API Key? · ebb9ef69621d4db32c5e
✔ What is your Pusher Cluster? · eu
✔ What is your Pusher broadcasting auth URL? · https://your-api.com/api/broadcasting/auth
✔ What is your Google Maps API Key? · AIzaSyAQqMr2FETas5l0ua7zSAzH9MunnyXJD58
✔ Do you want to automatically add chat routes to Router.dart? · Yes
✔ Do you want to automatically register chat repositories in Locator.dart? · Yes
```

---

## 2. Configuration | الإعدادات

### 2.1 Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Core
  dio: ^5.8.0+1
  bloc: ^8.1.2
  flutter_bloc: ^8.1.3
  get_it: ^7.6.0

  # Real-time & Video
  pusher_channels_flutter: ^2.2.1
  agora_uikit:
    git:
      url: https://github.com/eng-sayed/VideoUIKit-Flutter-min-SDK-21.git
      ref: test

  # Media & Files
  image_picker:
  file_picker: ^10.1.9
  record: ^6.0.0
  audioplayers: ^6.1.0
  video_player: ^2.9.5
  cached_network_image: ^3.2.3

  # Maps & Location
  google_maps_flutter: ^2.12.1
  geolocator: ^14.0.0
  geocoding: ^3.0.0
  url_launcher: ^6.3.1

  # UI
  gap: ^3.0.1
  emoji_picker_flutter: ^3.1.0
  photo_view: ^0.15.0
  shimmer: ^3.0.0
  flutter_svg: ^2.0.7
  infinite_scroll_pagination: ^4.1.0

  # Localization
  easy_localization: ^3.0.2

  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Firebase
  firebase_core:
  firebase_messaging: ^15.1.3

  # Utils
  permission_handler:
  path_provider: ^2.1.4
  lottie: ^1.3.0
  bot_toast: ^4.0.3
  flutter_smart_dialog: ^4.8.2
```

Then run:

```bash
flutter pub get
```

### 2.2 Android Configuration

#### `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>

    <application
        android:label="Your App"
        android:icon="@mipmap/ic_launcher">

        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY"/>

        <!-- ... rest of your config ... -->
    </application>
</manifest>
```

#### `android/app/build.gradle`

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21  // Required for Agora
        targetSdkVersion 34
    }
}
```

### 2.3 iOS Configuration

#### `ios/Runner/Info.plist`

```xml
<dict>
    <!-- Permission Descriptions -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to send photos and make video calls</string>

    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access for voice messages and video calls</string>

    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access to share your location in chat</string>

    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to send images in chat</string>

    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>This app needs access to save photos from chat</string>

    <!-- Google Maps API Key -->
    <key>GMSApiKey</key>
    <string>YOUR_GOOGLE_MAPS_API_KEY</string>

    <!-- ... rest of your config ... -->
</dict>
```

### 2.4 Firebase Setup

1. **Create Firebase Project**: https://console.firebase.google.com/

2. **Add Android App**:

   - Download `google-services.json`
   - Place in `android/app/`

3. **Add iOS App**:

   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`

4. **Configure Firebase**:
   ```bash
   flutterfire configure
   ```

### 2.5 Pusher Setup

1. **Create Pusher App**: https://dashboard.pusher.com/

2. **Note your credentials**:

   - App ID
   - Key
   - Secret
   - Cluster

3. **Backend Setup**: Your backend must handle Pusher authentication at `/api/broadcasting/auth`

---

## 3. API Integration | تكامل الـ API

### Required Endpoints

#### 3.1 Get Chats List

```
GET /api/chats/my-chats?page=1
```

**Headers**:

```
Authorization: Bearer {token}
Accept: application/json
```

**Response**:

```json
{
  "status": true,
  "data": [
    {
      "chat_id": "123",
      "other_party": {
        "type": "company",
        "id": "456",
        "name": "John Doe",
        "company": {
          "company_name": "Tech Corp",
          "company_image": "https://example.com/image.jpg"
        }
      },
      "last_message": {
        "id": "789",
        "content": "Hello!",
        "sent_at": "2025-01-13 10:30:00",
        "sent_by_me": false
      },
      "unseen_count": "3"
    }
  ],
  "pagination": {
    "lastPage": 5
  }
}
```

#### 3.2 Get Chat Messages

```
GET /api/chats/messages?chat_id=123&page=1
```

**Response**:

```json
{
  "status": true,
  "data": {
    "messages": [
      {
        "id": "1",
        "chat_id": "123",
        "sender_id": "456",
        "receiver_id": "789",
        "sender_name": "John",
        "sender_avatar": "https://...",
        "content": "Hello!",
        "media_url": null,
        "voice_duration": null,
        "sent_at": "2025-01-13 10:30:00",
        "lat": null,
        "long": null
      }
    ]
  },
  "pagination": {
    "lastPage": 10
  }
}
```

#### 3.3 Send Message

```
POST /api/chats/send-message
Content-Type: multipart/form-data
```

**Body**:

```
chat_id: 123
message: Hello!
file: (binary) // Optional - for images/voice
is_voice: 1    // Optional - if voice message
voice_duration: 15 // Optional - duration in seconds
```

**Response**:

```json
{
  "status": true,
  "data": {
    "message": {
      "id": "new_message_id",
      "chat_id": "123",
      "content": "Hello!",
      "sent_at": "2025-01-13 10:35:00"
    }
  }
}
```

#### 3.4 Send Location

```
POST /api/chats/send-location
Content-Type: multipart/form-data
```

**Body**:

```
chat_id: 123
lat: 24.7136
long: 46.6753
```

#### 3.5 Get Agora Token

```
POST /api/agora/token
```

**Body**:

```json
{
  "chat_id": "123"
}
```

**Response**:

```json
{
  "status": true,
  "data": {
    "token": "agora_rtc_token_here",
    "from_id": 456
  }
}
```

#### 3.6 Pusher Broadcasting Auth

```
POST /api/broadcasting/auth
```

**Body**:

```json
{
  "socket_id": "123.456",
  "channel_name": "private-Chat.123"
}
```

**Response**:

```json
{
  "auth": "your_auth_signature"
}
```

---

## 4. Usage Examples | أمثلة الاستخدام

### 4.1 Navigate to Chats Screen

```dart
import 'package:flutter/material.dart';
import 'core/Router/Router.dart';

// Simple navigation
Navigator.pushNamed(context, Routes.chatsScreen);
```

### 4.2 Open Chat with User

```dart
import 'core/Router/Router.dart';

Navigator.pushNamed(
  context,
  Routes.chatScreen,
  arguments: ChatArgs(
    chatId: "123",  // Existing chat ID (optional)
    userId: "456",  // User ID to chat with
    name: "Tech Corp (John Doe)",
    image: "https://example.com/logo.jpg",
  ),
);
```

### 4.3 Start Video Call

```dart
// First, get Agora token from your backend
final chatCubit = ChatCubit.get(context);
final result = await chatCubit.getAgoraToken(chatId: "123");

if (result != null) {
  final (token, uid) = result;

  Navigator.pushNamed(
    context,
    Routes.videoCallScreen,
    arguments: VideoCallArgs(
      channelName: "chat_123",
      token: token,
      uid: uid,
    ),
  );
}
```

### 4.4 Access Chat from Different Screens

```dart
// From notification
void handleNotification(Map<String, dynamic> data) {
  Navigator.pushNamed(
    context,
    Routes.chatScreen,
    arguments: ChatArgs(
      chatId: data['chat_id'],
      name: data['sender_name'],
      image: data['sender_image'],
    ),
  );
}

// From user profile
void openChatWithUser(String userId, String name, String image) {
  Navigator.pushNamed(
    context,
    Routes.chatScreen,
    arguments: ChatArgs(
      userId: userId,  // Will create new chat if doesn't exist
      name: name,
      image: image,
    ),
  );
}
```

---

## 5. Customization | التخصيص

### 5.1 Change Theme Colors

Edit `lib/core/theme/light_theme.dart`:

```dart
ThemeData getTheme() {
  return ThemeData(
    primaryColor: Color(0xFF2ECC71),  // Your brand color
    colorScheme: ColorScheme.light(
      primary: Color(0xFF2ECC71),
      secondary: Color(0xFF3498DB),
    ),
    // ... rest of theme
  );
}
```

### 5.2 Customize Message Bubble

Edit `lib/features/chat/presentation/widgets/message_bubble.dart`:

```dart
// Change bubble color
final bubbleColor = message.sentByMe
    ? Theme.of(context).primaryColor  // Sent messages
    : Colors.grey[200];                // Received messages

// Change text color
final textColor = message.sentByMe
    ? Colors.white
    : Colors.black87;
```

### 5.3 Add Custom Message Types

1. Update `MessageModel` in `chat_model.dart`:

```dart
class MessageModel {
  // ... existing fields ...
  String? customType;  // Add new field
  Map<String, dynamic>? customData;
}
```

2. Update `message_bubble.dart`:

```dart
if (message.customType == 'my_custom_type') {
  return MyCustomMessageWidget(message: message);
}
```

### 5.4 Modify Translations

Edit translation files:

**`assets/translations/ar-EG.json`**:

```json
{
  "conversations": "المحادثات",
  "no_previous_conversations": "لا توجد محادثات سابقة",
  "send_message": "إرسال رسالة"
}
```

**`assets/translations/en-US.json`**:

```json
{
  "conversations": "Conversations",
  "no_previous_conversations": "No previous conversations",
  "send_message": "Send message"
}
```

---

## 6. Advanced Features | المميزات المتقدمة

### 6.1 Handle Real-time Events

The chat automatically handles Pusher events. To add custom handling:

```dart
// In chat_cubit.dart
void _handleServerEvent(Map<String, dynamic> data) {
  // Existing message handling
  if (data["message"] != null) {
    final message = MessageModel.fromMap(data["message"]);
    // ... handle message
  }

  // Add custom event handling
  if (data["typing"] != null) {
    emit(UserTypingState(userId: data["user_id"]));
  }

  if (data["online_status"] != null) {
    emit(UserOnlineState(
      userId: data["user_id"],
      isOnline: data["is_online"],
    ));
  }
}
```

### 6.2 Add Message Delivery Status

1. Update model:

```dart
class MessageModel {
  bool? isDelivered;
  bool? isRead;
}
```

2. Show status in UI:

```dart
// In message_bubble.dart
Row(
  children: [
    Text(message.hour),
    if (message.sentByMe) ...[
      SizedBox(width: 4),
      Icon(
        message.isRead ? Icons.done_all : Icons.done,
        size: 16,
        color: message.isRead ? Colors.blue : Colors.grey,
      ),
    ],
  ],
)
```

### 6.3 Implement Search

```dart
class ChatsCubit extends Cubit<ChatsStates> {
  List<ChatModel> allChats = [];
  List<ChatModel> filteredChats = [];

  void searchChats(String query) {
    if (query.isEmpty) {
      filteredChats = allChats;
    } else {
      filteredChats = allChats.where((chat) {
        return chat.other_party?.company?.companyName
            ?.toLowerCase()
            .contains(query.toLowerCase()) ?? false;
      }).toList();
    }
    emit(ChatsSearchState());
  }
}
```

---

## 7. Best Practices | أفضل الممارسات

### 7.1 Token Management

```dart
// Store token securely
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save token
await storage.write(key: 'auth_token', value: token);
Utils.token = token;

// Load token on app start
final token = await storage.read(key: 'auth_token');
if (token != null) {
  Utils.token = token;
}
```

### 7.2 Error Handling

```dart
try {
  final result = await chatRepository.sendMessage(...);
  if (result != null) {
    // Success
  } else {
    Alerts.snack(text: "Failed to send message", state: SnackState.failed);
  }
} catch (e) {
  Alerts.snack(text: "Network error", state: SnackState.failed);
}
```

### 7.3 Performance Optimization

```dart
// Use const constructors where possible
const MessageBubble(message: message);

// Implement efficient pagination
final int pageSize = 20;  // Load 20 messages at a time

// Cache images
CachedNetworkImage(
  imageUrl: url,
  cacheKey: 'chat_image_${message.id}',
);
```

### 7.4 Memory Management

```dart
@override
void dispose() {
  chatpagingcontroller.dispose();
  scrollController.dispose();
  pusher.disconnect();
  super.dispose();
}
```

---

## 8. Troubleshooting | حل المشاكل

### Issue: Pusher Not Connecting

**Symptoms**: Messages not received in real-time

**Solutions**:

1. Check Pusher credentials in `chat_cubit.dart`
2. Verify auth URL is correct
3. Ensure `Utils.token` is set
4. Check backend logs for auth errors
5. Test Pusher connection in dashboard

### Issue: Video Call Not Working

**Symptoms**: Black screen or crash on video call

**Solutions**:

1. Ensure Agora App ID is correct
2. Check permissions are granted
3. Test on real device (not simulator)
4. Verify network connection
5. Check Agora token is valid

### Issue: Maps Not Showing

**Symptoms**: Blank map or error

**Solutions**:

1. Verify Google Maps API key in 3 locations:
   - `static_map.dart`
   - `AndroidManifest.xml`
   - `Info.plist`
2. Enable Maps SDK in Google Cloud Console
3. Check billing is enabled
4. Verify API key restrictions

### Issue: Voice Recording Fails

**Symptoms**: Cannot record voice messages

**Solutions**:

1. Check microphone permission
2. Test on real device
3. Verify `record` package version
4. Check storage permission
5. Ensure `path_provider` is working

---

## 🎯 Next Steps

1. ✅ Complete all configuration steps
2. ✅ Test on real devices
3. ✅ Customize UI to match your brand
4. ✅ Add analytics tracking
5. ✅ Implement push notifications
6. ✅ Test error scenarios
7. ✅ Optimize performance
8. ✅ Deploy to production

---

**Need more help?** Check:

- [README.md](README.md) - Overview
- [DEPENDENCIES.md](DEPENDENCIES.md) - Full dependencies list
- [CHANGELOG.md](CHANGELOG.md) - Version history

---

**Happy Coding! 🚀**
