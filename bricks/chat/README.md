# 💬 Chat Brick | قالب الشات

Complete standalone chat module with real-time messaging, voice, video calls, and location sharing for Flutter applications using Mason.

نموذج شات كامل مع رسائل فورية، صوت، مكالمات فيديو، ومشاركة المواقع لتطبيقات Flutter باستخدام Mason.

---

## ✨ Features | المميزات

### 🎯 Core Features | المميزات الأساسية

- ✅ **Real-time Messaging** - رسائل فورية باستخدام Pusher
- ✅ **Text Messages** - رسائل نصية
- ✅ **Image Sharing** - مشاركة الصور
- ✅ **Voice Messages** - رسائل صوتية بالتسجيل والتشغيل
- ✅ **Video Calls** - مكالمات فيديو باستخدام Agora
- ✅ **Location Sharing** - مشاركة المواقع مع خرائط Google
- ✅ **File Sharing** - مشاركة الملفات (PDF, Documents)
- ✅ **Chat Bot** - دردشة مع البوت
- ✅ **Pagination** - تحميل الرسائل بشكل تدريجي
- ✅ **Multi-language** - دعم العربية والإنجليزية

### 🎨 UI Features | مميزات الواجهة

- ✅ **Modern UI** - واجهة عصرية وسهلة الاستخدام
- ✅ **Message Bubbles** - فقاعات رسائل مميزة
- ✅ **Emoji Picker** - لوحة اختيار الإيموجي
- ✅ **Voice Player** - مشغل الرسائل الصوتية
- ✅ **Image Viewer** - عارض الصور بالتكبير والتصغير
- ✅ **Empty States** - حالات فارغة جميلة
- ✅ **Loading States** - حالات تحميل سلسة

---

## 📋 What's Included | المحتويات

This brick generates 3 complete features:

### 1️⃣ Chats Feature (قائمة المحادثات)

```
lib/features/chats/
├── cubit/
│   ├── chats_cubit.dart
│   └── chats_states.dart
├── domain/
│   ├── model/chats_model.dart
│   ├── repository/repository.dart
│   └── request/chats_request.dart
└── presentation/
    ├── screens/chats_screen.dart
    └── widgets/widgets.dart
```

### 2️⃣ Chat Feature (المحادثة الفردية)

```
lib/features/chat/
├── cubit/
│   ├── chat_cubit.dart
│   └── chat_states.dart
├── domain/
│   ├── model/chat_model.dart
│   ├── repository/repository.dart
│   └── request/chat_request.dart
└── presentation/
    ├── screens/
    │   ├── chat_screen.dart
    │   ├── full_image_chat.dart
    │   └── video_call_screen.dart
    └── widgets/
        ├── chat_app_bar.dart
        ├── chat_input_bar.dart
        ├── message_bubble.dart
        ├── voice_player_widget.dart
        ├── voice_recorder_widget.dart
        ├── static_map.dart
        └── attachment_options_sheet.dart
```

### 3️⃣ Chat Bot Feature (البوت)

```
lib/features/chat_bot/
├── cubit/
├── domain/
└── presentation/
```

---

## 🚀 Quick Start | البدء السريع

### Prerequisites | المتطلبات

1. **Mason CLI installed** - تثبيت Mason

   ```bash
   dart pub global activate mason_cli
   ```

2. **Project Template brick** - قالب المشروع
   ```bash
   mason make project_template -o ./lib
   ```

### Installation | التثبيت

1. **Add to mason.yaml**:

   ```yaml
   bricks:
     chat:
       path: ./bricks/chat
   ```

2. **Get the brick**:

   ```bash
   mason get
   ```

3. **Generate the module**:

   ```bash
   mason make chat -o ./lib/features
   ```

4. **Follow the prompts**:
   - Base URL: `https://your-api.com/api/`
   - Pusher API Key: `your_pusher_key`
   - Pusher Cluster: `eu`
   - Pusher Auth URL: `https://your-api.com/api/broadcasting/auth`
   - Google Maps API Key: `your_google_maps_key`
   - Add to Router: `Y`
   - Register Repositories: `Y`

---

## ⚙️ Configuration | الإعدادات

### 1️⃣ Pusher Setup

The brick uses Mason variables for Pusher configuration. During generation, you'll be asked for:

- **Pusher API Key** - من Pusher Dashboard
- **Pusher Cluster** - مثل `eu`, `us2`, etc.
- **Pusher Auth URL** - Backend endpoint للمصادقة

These will be automatically inserted in `chat/cubit/chat_cubit.dart`.

### 2️⃣ Google Maps Setup

You'll be asked for your **Google Maps API Key** during generation. This will be inserted in:

- `chat/presentation/widgets/static_map.dart`

**Don't forget to also add it to:**

- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

### 3️⃣ Firebase Setup

Add your Firebase configuration files:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

### 4️⃣ Base URL

Set your API base URL in `lib/core/config/key.dart`:

```dart
static const String baseUrl = 'https://your-api.com/api/';
```

---

## 📦 Dependencies | الاعتمادات

See [DEPENDENCIES.md](DEPENDENCIES.md) for:

- Complete list of required packages
- Platform-specific configurations
- Required project structure
- Setup instructions

---

## 🎯 Usage | الاستخدام

### Navigate to Chats Screen

```dart
Navigator.pushNamed(context, Routes.chatsScreen);
```

### Navigate to Chat Screen

```dart
Navigator.pushNamed(
  context,
  Routes.chatScreen,
  arguments: ChatArgs(
    chatId: "123",
    name: "Company Name",
    image: "https://example.com/image.jpg",
  ),
);
```

### Start Video Call

```dart
Navigator.pushNamed(
  context,
  Routes.videoCallScreen,
  arguments: VideoCallArgs(
    channelName: "room_123",
    token: "agora_token",
    uid: 12345,
  ),
);
```

---

## 🔧 Customization | التخصيص

### Change Colors

Update theme in `lib/core/theme/`:

- `light_theme.dart`
- `dark_theme.dart`

### Change Strings

Update translations in:

- `assets/translations/ar-EG.json`
- `assets/translations/en-US.json`

### Modify UI

All widgets are in:

- `chat/presentation/widgets/`
- `chats/presentation/widgets/`

---

## 🐛 Troubleshooting | حل المشاكل

### "Pusher not connecting"

- ✅ Check API Key and Cluster
- ✅ Verify auth URL is correct
- ✅ Ensure token is set in Utils.token

### "Maps not showing"

- ✅ Add Google Maps API key in all 3 locations
- ✅ Enable Maps SDK in Google Cloud Console

### "Permissions denied"

- ✅ Add all required permissions in AndroidManifest.xml
- ✅ Add usage descriptions in Info.plist

### "Package not found"

- ✅ Run `flutter pub get`
- ✅ Check all dependencies in pubspec.yaml

---

## 📚 API Endpoints Required | نقاط النهاية المطلوبة

Your backend must have:

```
GET  /api/chats/my-chats              - Get chats list
GET  /api/chats/messages              - Get chat messages
POST /api/chats/send-message          - Send message
POST /api/chats/send-location         - Send location
POST /api/agora/token                 - Get Agora token
POST /api/broadcasting/auth           - Pusher authentication
```

---

## 🤝 Contributing | المساهمة

This brick is part of the flutter-structure project. For improvements:

1. Fork the repository
2. Make your changes
3. Submit a pull request

---

## 📄 License | الترخيص

MIT License - See LICENSE file for details

---

## 🆘 Support | الدعم

For issues or questions:

- Check DEPENDENCIES.md
- Review troubleshooting section
- Open an issue on GitHub

---

**Made with ❤️ for the Flutter community**

**صُنع بـ ❤️ لمجتمع Flutter**
