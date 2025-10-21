import 'package:flutter/material.dart';

/// نظام الألوان الديناميكي للتطبيق
/// الألوان تتغير تلقائياً حسب الثيم (فاتح/داكن)
class AppColors {
  AppColors._();

  // ==================== DYNAMIC COLOR GETTERS ====================

  /// التحقق من الثيم الداكن
  static bool _isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// اللون الأساسي - يتغير حسب الثيم
  static Color primary(BuildContext context) {
    return _isDarkMode(context) ? _darkPrimary : _lightPrimary;
  }

  /// اللون الثانوي - يتغير حسب الثيم
  static Color secondary(BuildContext context) {
    return _isDarkMode(context) ? _darkSecondary : _lightSecondary;
  }

  /// لون الخلفية - يتغير حسب الثيم
  static Color background(BuildContext context) {
    return _isDarkMode(context) ? _darkBackground : _lightBackground;
  }

  /// اللون على الخلفية - يتغير حسب الثيم
  static Color onBackground(BuildContext context) {
    return _isDarkMode(context) ? _darkOnBackground : _lightOnBackground;
  }

  /// لون السطح - يتغير حسب الثيم
  static Color surface(BuildContext context) {
    return _isDarkMode(context) ? _darkSurface : _lightSurface;
  }

  /// اللون على السطح - يتغير حسب الثيم
  static Color onSurface(BuildContext context) {
    return _isDarkMode(context) ? _darkOnSurface : _lightOnSurface;
  }

  /// لون السطح المتغير - يتغير حسب الثيم
  static Color surfaceVariant(BuildContext context) {
    return _isDarkMode(context) ? _darkSurfaceVariant : _lightSurfaceVariant;
  }

  /// اللون على السطح المتغير - يتغير حسب الثيم
  static Color onSurfaceVariant(BuildContext context) {
    return _isDarkMode(context)
        ? _darkOnSurfaceVariant
        : _lightOnSurfaceVariant;
  }

  /// لون الحدود - يتغير حسب الثيم
  static Color border(BuildContext context) {
    return _isDarkMode(context) ? _darkBorder : _lightBorder;
  }

  /// لون الظل - يتغير حسب الثيم
  static Color shadow(BuildContext context) {
    return _isDarkMode(context) ? _darkShadow : _lightShadow;
  }

  // ==================== LIGHT THEME COLORS ====================

  static const Color _lightPrimary = Color(0xFF6200EE);
  static const Color _lightSecondary = Color(0xFF03DAC6);
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightOnBackground = Color(0xFF000000);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightOnSurface = Color(0xFF000000);
  static const Color _lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color _lightOnSurfaceVariant = Color(0xFF424242);
  static const Color _lightBorder = Color(0xFFE0E0E0);
  static const Color _lightShadow = Color(0x1A000000);

  // ==================== DARK THEME COLORS ====================

  static const Color _darkPrimary = Color(0xFFBB86FC);
  static const Color _darkSecondary = Color(0xFF03DAC6);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkOnBackground = Color(0xFFFFFFFF);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkOnSurface = Color(0xFFFFFFFF);
  static const Color _darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color _darkOnSurfaceVariant = Color(0xFFBDBDBD);
  static const Color _darkBorder = Color(0xFF424242);
  static const Color _darkShadow = Color(0x4D000000);

  // ==================== STATUS COLORS (FIXED) ====================

  /// لون النجاح
  static const Color success = Color(0xFF4CAF50);

  /// لون الخطأ
  static const Color error = Color(0xFFE53E3E);

  /// لون التحذير
  static const Color warning = Color(0xFFFF9800);

  /// لون المعلومات
  static const Color info = Color(0xFF2196F3);

  // ==================== NEUTRAL COLORS (FIXED) ====================

  /// الأبيض
  static const Color white = Color(0xFFFFFFFF);

  /// الأسود
  static const Color black = Color(0xFF000000);

  /// الرمادي الفاتح
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ==================== BORDER COLORS (FIXED) ====================

  /// لون الحدود المحدد
  static const Color borderFocused = Color(0xFF6200EE);

  /// لون حدود الخطأ
  static const Color borderError = Color(0xFFE53E3E);

  // ==================== HELPER METHODS ====================

  /// إنشاء MaterialColor من لون
  static MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  /// الحصول على لون مع الشفافية
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}
