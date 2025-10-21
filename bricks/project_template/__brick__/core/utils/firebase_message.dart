import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../localization/localization_helper.dart';
import 'utils.dart';

/// نظام إدارة إشعارات Firebase
/// Firebase Messaging Management System
class FBMessaging {
  FBMessaging._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin? _notificationsPlugin;
  static bool _isInitialized = false;

  // ==================== NOTIFICATION CHANNELS ====================

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // ==================== BACKGROUND HANDLERS ====================

  /// معالج الإشعارات في الخلفية
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    await _setNotificationPresentationOptions();
    log('Background message received: ${message.messageId}');
  }

  /// معالج النقر على الإشعارات
  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationHandler(
    NotificationResponse response,
  ) async {
    if (response.payload != null) {
      try {
        final data = json.decode(response.payload!);
        final notification = FCMNotification.fromMap(data);
        _handleNotificationOnClick(notification, appIsOpened: false);
      } catch (e) {
        log('Error parsing notification payload: $e');
      }
    }
  }

  // ==================== INITIALIZATION ====================

  /// تهيئة نظام الإشعارات
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
      await _setupNotificationChannels();
      await _requestPermissions();
      await _configureMessagingHandlers();
      await _getToken();
      await _messaging.subscribeToTopic("all");

      _isInitialized = true;
      log('Firebase Messaging initialized successfully');
    } catch (e) {
      log('Error initializing Firebase Messaging: $e');
    }
  }

  // ==================== NOTIFICATION SETUP ====================

  /// إعداد قنوات الإشعارات
  static Future<void> _setupNotificationChannels() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    await _notificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
    );

    await _notificationsPlugin?.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: onBackgroundNotificationHandler,
    );
  }

  /// طلب أذونات الإشعارات
  static Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _setNotificationPresentationOptions();
  }

  /// إعداد خيارات عرض الإشعارات
  static Future<void> _setNotificationPresentationOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ==================== MESSAGE HANDLERS ====================

  /// تكوين معالجات الرسائل
  static Future<void> _configureMessagingHandlers() async {
    // معالجة الرسالة الأولية عند تشغيل التطبيق
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      try {
        FCMNotification notification = FCMNotification.fromMap(
          initialMessage.data,
        );
        _handleNotificationOnClick(notification, appIsOpened: false);
      } catch (e) {
        log('Error handling initial message: $e');
      }
    }

    // معالجة الرسائل في المقدمة
    FirebaseMessaging.onMessage.listen(
      (message) => _processMessageInForeground(message, appIsOpened: true),
    );

    // معالجة الرسائل عند فتح التطبيق من الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      try {
        FCMNotification notification = FCMNotification.fromMap(message.data);
        _handleNotificationOnClick(notification, appIsOpened: false);
      } catch (e) {
        log('Error handling message opened app: $e');
      }
    });
  }

  /// معالجة الرسائل في المقدمة
  static Future<void> _processMessageInForeground(
    RemoteMessage message, {
    required bool appIsOpened,
    bool showNotification = true,
  }) async {
    log('Message received in foreground: ${message.messageId}');
    log('Message data: ${message.data}');
    log('Message title: ${message.notification?.title}');
    log('Message body: ${message.notification?.body}');

    // تخطي إشعارات الدردشة للغرفة الحالية
    if (_shouldSkipChatNotification(message)) {
      return;
    }

    // عرض الإشعار
    if (showNotification) {
      await _showNotification(message);
    }
  }

  /// التحقق من تخطي إشعارات الدردشة
  static bool _shouldSkipChatNotification(RemoteMessage message) {
    return message.data['type'] == 'chat' &&
        message.data['model_id']?.toString() == Utils.FCMToken;
  }

  /// عرض الإشعار
  static Future<void> _showNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    try {
      await _notificationsPlugin?.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  // ==================== TOKEN MANAGEMENT ====================

  /// الحصول على رمز FCM
  static Future<void> _getToken() async {
    try {
      final token = await _messaging.getToken();
      log('FCM Token: $token');
      Utils.FCMToken = token ?? '';
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  /// إلغاء رمز FCM
  static Future<void> revokeToken() async {
    try {
      await _messaging.deleteToken();
      Utils.FCMToken = "";
      log('FCM token revoked');
    } catch (e) {
      log('Error revoking FCM token: $e');
    }
  }

  // ==================== TOPIC MANAGEMENT ====================

  /// الاشتراك في مواضيع العميل
  static Future<void> subscribeToClient() async {
    try {
      await _messaging.subscribeToTopic("all");
      await _messaging.subscribeToTopic("client");
      log("Subscribed to client topics");
    } catch (e) {
      log('Error subscribing to client topics: $e');
    }
  }

  /// إلغاء الاشتراك من مواضيع العميل
  static Future<void> unsubscribeFromClient() async {
    try {
      await _messaging.unsubscribeFromTopic("all");
      await _messaging.unsubscribeFromTopic("client");
      log("Unsubscribed from client topics");
    } catch (e) {
      log('Error unsubscribing from client topics: $e');
    }
  }

  /// الاشتراك في مواضيع المزود
  static Future<void> subscribeToProvider() async {
    try {
      await _messaging.subscribeToTopic("all");
      await _messaging.subscribeToTopic("provider");
      log("Subscribed to provider topics");
    } catch (e) {
      log('Error subscribing to provider topics: $e');
    }
  }

  /// إلغاء الاشتراك من مواضيع المزود
  static Future<void> unsubscribeFromProvider() async {
    try {
      await _messaging.unsubscribeFromTopic("all");
      await _messaging.unsubscribeFromTopic("provider");
      log("Unsubscribed from provider topics");
    } catch (e) {
      log('Error unsubscribing from provider topics: $e');
    }
  }

  // ==================== NOTIFICATION HANDLING ====================

  /// معالجة النقر على الإشعار
  static void _handleNotificationOnClick(
    FCMNotification notification, {
    bool appIsOpened = false,
  }) {
    log('Notification clicked: ${notification.type}');
    log('Notification model ID: ${notification.modelId}');

    // معالجة إشعارات الخدمة
    if (notification.type == "service" && notification.modelId != null) {
      // TODO: Handle service notification navigation
      log('Service notification: ${notification.modelId}');
    }

    // معالجة إشعارات الدردشة
    if (notification.type == "chat" && notification.modelId != null) {
      // TODO: Handle chat notification navigation
      log('Chat notification: ${notification.modelId}');
    }

    // معالجة إشعارات الإعلانات
    if (notification.type == "ad") {
      // TODO: Handle ad notification navigation
      log('Ad notification');
    }
  }
}

// ==================== NOTIFICATION MODEL ====================

/// نموذج إشعار FCM
/// FCM Notification Model
class FCMNotification {
  final String? title;
  final String? message;
  final String? type;
  final String? modelId;

  FCMNotification({this.title, this.message, this.type, this.modelId});

  /// إنشاء من Map
  factory FCMNotification.fromMap(Map<String, dynamic> map) {
    return FCMNotification(
      title: map["title"],
      message: map["message"],
      type: map["type"],
      modelId: map["model_id"]?.toString(),
    );
  }

  /// تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "message": message,
      "type": type,
      "model_id": modelId,
    };
  }

  @override
  String toString() {
    return 'FCMNotification(title: $title, message: $message, type: $type, modelId: $modelId)';
  }
}
