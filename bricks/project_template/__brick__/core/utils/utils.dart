import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import '../cache/hive_service.dart';
import '../services/media/media_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'general_constants.dart';
import 'validations.dart';

/// نظام الأدوات المساعدة للتطبيق
/// Application Utilities System
class Utils {
  Utils._();

  // ==================== STATIC VARIABLES ====================

  /// رمز الوصول للمستخدم
  static String token = '';

  /// اللغة الحالية
  static String lang = '';

  /// رمز FCM للإشعارات
  static String FCMToken = '';

  /// نوع المستخدم
  static String userType = "";

  /// مفتاح Scaffold الرئيسي
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ==================== GETTERS ====================

  /// الحصول على خدمة الوسائط
  static MediaService get media => MediaService();

  // ==================== USER MANAGEMENT ====================

  /// حفظ بيانات المستخدم في Hive
  static Future<void> saveUserInHive(Map<String, dynamic> response) async {
    // TODO: Implement user saving logic
    // userModel = UserModel.fromJson(response);
    // token = userModel.token ?? '';
  }

  // ==================== UI UTILITIES ====================

  /// إعادة بناء جميع العناصر الفرعية
  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  /// إصلاح مشكلة RTL في آخر حرف
  static void fixRtlLastChar(TextEditingController? controller) {
    if (controller != null) {
      if (controller.selection ==
          TextSelection.fromPosition(
            TextPosition(offset: (controller.text.length) - 1),
          )) {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    }
  }

  // ==================== GENERATORS ====================

  /// توليد باركود عشوائي
  static String generateBarcode() {
    return (Random().nextInt(99999999) + 10000000).toString();
  }

  /// توليد معرف فريد
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // ==================== FILE UTILITIES ====================

  /// الحصول على حجم الملف بالميجابايت
  static double getFileSizeInMB(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    final mb = kb / 1024;
    return mb;
  }

  /// الحصول على حجم الملف بالكيلوبايت
  static double getFileSizeInKB(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    return kb;
  }

  // ==================== THEME MANAGEMENT ====================

  /// تهيئة الثيم
  static Future<void> initTheme() async {
    // TODO: Implement theme initialization
    // This will be handled by AppThemeManager
  }

  // ==================== LANGUAGE UTILITIES ====================

  /// الحصول على اللغة الحالية
  static String getCurrentLanguage() {
    return EasyLocalization.of(EasyLocalization.navigatorKey.currentContext!)?.locale.languageCode ?? 'en';
  }

  /// التحقق من اللغة العربية
  static bool isArabic() {
    return EasyLocalization.of(EasyLocalization.navigatorKey.currentContext!)?.locale.languageCode == 'ar';
  }

  // ==================== VALIDATION UTILITIES ====================

  /// التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    return Validation.emailValidation(email) == null;
  }

  /// التحقق من صحة رقم الهاتف
  static bool isValidPhone(String phone) {
    return Validation.phoneValidation(phone) == null;
  }

  // ==================== STRING UTILITIES ====================

  /// تنظيف النص من المسافات الزائدة
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// تحويل النص إلى عنوان
  static String toTitleCase(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
