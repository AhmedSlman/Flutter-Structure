import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Easy Localization Helper
/// نظام الترجمة المبسط باستخدام Easy Localization

class LocalizationHelper {
  LocalizationHelper._();
  static final LocalizationHelper _instance = LocalizationHelper._();
  factory LocalizationHelper() => _instance;

  /// اللغات المدعومة
  static const List<Locale> supportedLocales = [
    Locale('ar', 'EG'), // العربية
    Locale('en', 'US'), // الإنجليزية
  ];

  /// أسماء اللغات
  static const List<String> languageNames = ['العربية', 'English'];

  /// الحصول على اللغة الحالية
  static String get currentLanguageName {
    final currentLocale = EasyLocalization.of(
      navigatorKey.currentContext!,
    )?.locale;
    final index = supportedLocales.indexWhere(
      (locale) => locale.languageCode == currentLocale?.languageCode,
    );
    return languageNames[index >= 0 ? index : 0];
  }

  /// Navigator Key للوصول للـ context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// تغيير اللغة
  static Future<void> changeLanguage(String languageName) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final index = languageNames.indexOf(languageName);
    if (index >= 0) {
      await context.setLocale(supportedLocales[index]);
    }
  }

  /// تبديل اللغة
  static Future<void> toggleLanguage() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final currentLocale = EasyLocalization.of(context)?.locale;
    final isArabic = currentLocale?.languageCode == 'ar';

    await context.setLocale(
      isArabic ? supportedLocales[1] : supportedLocales[0],
    );
  }

  /// التحقق من اللغة الحالية
  static bool get isArabic {
    final context = navigatorKey.currentContext;
    if (context == null) return true;
    return EasyLocalization.of(context)?.locale?.languageCode == 'ar';
  }

  /// الحصول على النص المترجم
  static String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return key;
    return key.tr(args: args, namedArgs: namedArgs);
  }
}
