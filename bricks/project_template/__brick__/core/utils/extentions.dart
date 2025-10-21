import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../localization/localization_helper.dart';
import 'utils.dart';

// ==================== ASSET EXTENSIONS ====================

/// إضافات إدارة الأصول
/// Asset Management Extensions
extension Photo on String {
  /// الحصول على مسار الصورة PNG
  String png([String? path = "images"]) => 'assets/$path/$this.png';
  
  /// الحصول على مسار الأيقونة SVG
  String svg([String path = "icons"]) => 'assets/$path/$this.svg';
  
  /// الحصول على مسار الصورة JPEG
  String jpeg([String path = "images"]) => 'assets/$path/$this.jpg';
}

// ==================== DATE EXTENSIONS ====================

/// إضافات إدارة التواريخ
/// Date Management Extensions
extension Dates on String {
  /// استخراج اسم الملف من URL
  String nameFromUrl() {
    int index = lastIndexOf("/") + 1;
    return replaceRange(0, index, "");
  }

  /// تنسيق التاريخ
  String formattedDate([String format = "d - M - y"]) {
    if (isNotEmpty) {
      try {
        DateTime date = DateTime.parse(this);
        return DateFormat(format, LocalizationHelper.isArabic ? "ar" : "en").format(date);
      } catch (e) {
        return "";
      }
    }
    return "";
  }
}

// ==================== CONTEXT EXTENSIONS ====================

/// إضافات BuildContext
/// BuildContext Extensions
extension ContextExtensions on BuildContext {
  // ==================== SIZE EXTENSIONS ====================

  /// ارتفاع الشاشة
  double get height => MediaQuery.of(this).size.height;
  
  /// عرض الشاشة
  double get width => MediaQuery.of(this).size.width;
  
  /// نسبة العرض إلى الارتفاع
  double get aspectRatio => width / height;

  // ==================== THEME EXTENSIONS ====================

  /// بيانات الثيم
  ThemeData get theme => Theme.of(this);
  
  /// ثيم النصوص
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// نظام الألوان
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// التحقق من الثيم الداكن
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  
  /// التحقق من الثيم الفاتح
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  // ==================== NAVIGATION EXTENSIONS ====================

  /// الانتقال للصفحة السابقة
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  
  /// الانتقال لصفحة جديدة
  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (_) => page),
      );
  
  /// استبدال الصفحة الحالية
  Future<T?> pushReplacement<T>(Widget page) => Navigator.of(this).pushReplacement<T, dynamic>(
        MaterialPageRoute(builder: (_) => page),
      );
}

// ==================== PADDING EXTENSIONS ====================

/// إضافات المسافات
/// Padding Extensions
extension EmptyPadding on num {
  /// مسافة عمودية
  SizedBox get ph => SizedBox(height: toDouble());
  
  /// مسافة أفقية
  SizedBox get pw => SizedBox(width: toDouble());
}

// ==================== SLIVER EXTENSIONS ====================

/// إضافات Sliver
/// Sliver Extensions
extension MySLiverBox on Widget {
  /// تحويل إلى SliverToBoxAdapter
  SliverToBoxAdapter get sliverBox => SliverToBoxAdapter(child: this);
  
  /// تحويل إلى SliverToBoxAdapter مع حشو
  SliverToBoxAdapter get sliverPadding => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: this,
        ),
      );
}

// ==================== STRING EXTENSIONS ====================

/// إضافات النصوص
/// String Extensions
extension StringCasingExtension on String {
  /// تحويل أول حرف إلى كبير
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  
  /// تحويل إلى عنوان
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  // ==================== NUMBER EXTENSIONS ====================

  /// إزالة الصفر من بداية الرقم
  String get removeZero {
    if (startsWith("0")) {
      return substring(1);
    } else {
      return this;
    }
  }

  // ==================== TIME EXTENSIONS ====================

  /// تحويل الوقت إلى 24 ساعة
  String get to24h {
    try {
      final parse = DateFormat("hh:mm a", LocalizationHelper.isArabic ? "ar" : "en").parse(this);
      return DateFormat("HH:mm", "en").format(parse);
    } catch (e) {
      return this;
    }
  }

  // ==================== DATE FORMATTING ====================

  /// تنسيق التاريخ والوقت
  String get formatDateTime {
    var date = DateTime.tryParse(this) ?? DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm", "en").format(date);
  }

  /// تنسيق التاريخ والوقت مع الثواني
  String get formatDateTimeWithSeconds {
    var date = DateTime.tryParse(this) ?? DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss", "en").format(date);
  }

  /// تنسيق التاريخ فقط
  String get formatDateOnly {
    var date = DateTime.tryParse(this) ?? DateTime.now();
    return DateFormat("yyyy-MM-dd", "en").format(date);
  }

  // ==================== CONVERSION EXTENSIONS ====================

  /// تحويل إلى رقم عشري
  double toDouble() => double.tryParse(this) ?? "0") ?? 0;

  /// تحويل إلى لون من hex
  Color? toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }
}

// ==================== NUMBER EXTENSIONS ====================

/// إضافات الأرقام
/// Number Extensions
extension DoubleExtensions on num? {
  /// تقريب إلى رقمين عشريين
  String get roundTo2numberString {
    return this == null
        ? "0"
        : this!.truncateToDouble() == this!
            ? this!.toStringAsFixed(0)
            : this!.toStringAsFixed(2);
  }

  /// تقريب إلى أربعة أرقام عشريين
  String get roundTo4numberString {
    return this == null
        ? "0"
        : this!.truncateToDouble() == this!
            ? this!.toStringAsFixed(0)
            : this!.toStringAsFixed(4);
  }
}

// ==================== DATETIME EXTENSIONS ====================

/// إضافات DateTime
/// DateTime Extensions
extension FormatData on DateTime {
  /// تنسيق التاريخ والوقت
  String get formattedDateTime =>
      DateFormat("yyyy-MM-dd HH:mm", "en").format(this);
  
  /// تنسيق التاريخ فقط
  String get formattedDate =>
      DateFormat("yyyy-MM-dd", "en").format(this);
  
  /// تنسيق الوقت فقط
  String get formattedTime =>
      DateFormat("HH:mm", "en").format(this);
}

// ==================== LIST EXTENSIONS ====================

/// إضافات القوائم
/// List Extensions
extension LocalReverse on List {
  /// عكس القائمة حسب اللغة
  List get reverseLocal {
    if (LocalizationHelper.isArabic) {
      return reversed.toList();
    }
    return this;
  }
}
