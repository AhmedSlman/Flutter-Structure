import 'package:flutter/material.dart';

/// نظام الخطوط المبسط - Text Styles بسيطة وواضحة
class AppStyles {
  AppStyles._();

  // ==================== FONT FAMILIES ====================

  /// الخط الأساسي للإنجليزية
  static const String primaryFont = 'Roboto';

  /// الخط الأساسي للعربية
  static const String arabicFont = 'Cairo';

  /// الخط الافتراضي (يتم اختياره حسب اللغة)
  static String get defaultFont => _isArabic ? arabicFont : primaryFont;

  /// تحديد ما إذا كانت اللغة عربية
  static bool get _isArabic {
    // يمكن تحسين هذا لاحقاً ليعتمد على Localization
    return false; // افتراضي للإنجليزية
  }

  // ==================== FONT WEIGHTS ====================

  /// أوزان الخطوط
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ==================== TEXT STYLES - SIZES ====================

  /// أحجام الخطوط - نظام s14, s16, etc.

  // Small sizes
  static TextStyle get s10 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 10.0,
    fontWeight: regular,
    height: 1.2,
  );

  static TextStyle get s12 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 12.0,
    fontWeight: regular,
    height: 1.3,
  );

  static TextStyle get s14 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 14.0,
    fontWeight: regular,
    height: 1.4,
  );

  static TextStyle get s16 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 16.0,
    fontWeight: regular,
    height: 1.5,
  );

  static TextStyle get s18 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 18.0,
    fontWeight: regular,
    height: 1.4,
  );

  static TextStyle get s20 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 20.0,
    fontWeight: regular,
    height: 1.3,
  );

  static TextStyle get s24 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 24.0,
    fontWeight: regular,
    height: 1.2,
  );

  static TextStyle get s28 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 28.0,
    fontWeight: regular,
    height: 1.2,
  );

  static TextStyle get s32 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 32.0,
    fontWeight: regular,
    height: 1.1,
  );

  static TextStyle get s36 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 36.0,
    fontWeight: regular,
    height: 1.1,
  );

  static TextStyle get s48 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 48.0,
    fontWeight: regular,
    height: 1.0,
  );

  // ==================== TEXT STYLES - WEIGHTS ====================

  /// أوزان مختلفة لكل حجم

  // Light weights
  static TextStyle get s10Light => s10.copyWith(fontWeight: light);
  static TextStyle get s12Light => s12.copyWith(fontWeight: light);
  static TextStyle get s14Light => s14.copyWith(fontWeight: light);
  static TextStyle get s16Light => s16.copyWith(fontWeight: light);
  static TextStyle get s18Light => s18.copyWith(fontWeight: light);
  static TextStyle get s20Light => s20.copyWith(fontWeight: light);
  static TextStyle get s24Light => s24.copyWith(fontWeight: light);
  static TextStyle get s28Light => s28.copyWith(fontWeight: light);
  static TextStyle get s32Light => s32.copyWith(fontWeight: light);
  static TextStyle get s36Light => s36.copyWith(fontWeight: light);
  static TextStyle get s48Light => s48.copyWith(fontWeight: light);

  // Medium weights
  static TextStyle get s10Medium => s10.copyWith(fontWeight: medium);
  static TextStyle get s12Medium => s12.copyWith(fontWeight: medium);
  static TextStyle get s14Medium => s14.copyWith(fontWeight: medium);
  static TextStyle get s16Medium => s16.copyWith(fontWeight: medium);
  static TextStyle get s18Medium => s18.copyWith(fontWeight: medium);
  static TextStyle get s20Medium => s20.copyWith(fontWeight: medium);
  static TextStyle get s24Medium => s24.copyWith(fontWeight: medium);
  static TextStyle get s28Medium => s28.copyWith(fontWeight: medium);
  static TextStyle get s32Medium => s32.copyWith(fontWeight: medium);
  static TextStyle get s36Medium => s36.copyWith(fontWeight: medium);
  static TextStyle get s48Medium => s48.copyWith(fontWeight: medium);

  // SemiBold weights
  static TextStyle get s10SemiBold => s10.copyWith(fontWeight: semiBold);
  static TextStyle get s12SemiBold => s12.copyWith(fontWeight: semiBold);
  static TextStyle get s14SemiBold => s14.copyWith(fontWeight: semiBold);
  static TextStyle get s16SemiBold => s16.copyWith(fontWeight: semiBold);
  static TextStyle get s18SemiBold => s18.copyWith(fontWeight: semiBold);
  static TextStyle get s20SemiBold => s20.copyWith(fontWeight: semiBold);
  static TextStyle get s24SemiBold => s24.copyWith(fontWeight: semiBold);
  static TextStyle get s28SemiBold => s28.copyWith(fontWeight: semiBold);
  static TextStyle get s32SemiBold => s32.copyWith(fontWeight: semiBold);
  static TextStyle get s36SemiBold => s36.copyWith(fontWeight: semiBold);
  static TextStyle get s48SemiBold => s48.copyWith(fontWeight: semiBold);

  // Bold weights
  static TextStyle get s10Bold => s10.copyWith(fontWeight: bold);
  static TextStyle get s12Bold => s12.copyWith(fontWeight: bold);
  static TextStyle get s14Bold => s14.copyWith(fontWeight: bold);
  static TextStyle get s16Bold => s16.copyWith(fontWeight: bold);
  static TextStyle get s18Bold => s18.copyWith(fontWeight: bold);
  static TextStyle get s20Bold => s20.copyWith(fontWeight: bold);
  static TextStyle get s24Bold => s24.copyWith(fontWeight: bold);
  static TextStyle get s28Bold => s28.copyWith(fontWeight: bold);
  static TextStyle get s32Bold => s32.copyWith(fontWeight: bold);
  static TextStyle get s36Bold => s36.copyWith(fontWeight: bold);
  static TextStyle get s48Bold => s48.copyWith(fontWeight: bold);

  // ExtraBold weights
  static TextStyle get s10ExtraBold => s10.copyWith(fontWeight: extraBold);
  static TextStyle get s12ExtraBold => s12.copyWith(fontWeight: extraBold);
  static TextStyle get s14ExtraBold => s14.copyWith(fontWeight: extraBold);
  static TextStyle get s16ExtraBold => s16.copyWith(fontWeight: extraBold);
  static TextStyle get s18ExtraBold => s18.copyWith(fontWeight: extraBold);
  static TextStyle get s20ExtraBold => s20.copyWith(fontWeight: extraBold);
  static TextStyle get s24ExtraBold => s24.copyWith(fontWeight: extraBold);
  static TextStyle get s28ExtraBold => s28.copyWith(fontWeight: extraBold);
  static TextStyle get s32ExtraBold => s32.copyWith(fontWeight: extraBold);
  static TextStyle get s36ExtraBold => s36.copyWith(fontWeight: extraBold);
  static TextStyle get s48ExtraBold => s48.copyWith(fontWeight: extraBold);

  // ==================== COMMON USAGE STYLES ====================

  /// أنماط شائعة الاستخدام

  // Headers
  static TextStyle get header => s24Bold;
  static TextStyle get subHeader => s20SemiBold;
  static TextStyle get sectionTitle => s18Medium;

  // Body text
  static TextStyle get body => s16;
  static TextStyle get bodySmall => s14;
  static TextStyle get bodyLarge => s18;

  // Labels
  static TextStyle get label => s14Medium;
  static TextStyle get labelSmall => s12Medium;
  static TextStyle get labelLarge => s16Medium;

  // Buttons
  static TextStyle get button => s16Medium;
  static TextStyle get buttonSmall => s14Medium;
  static TextStyle get buttonLarge => s18Medium;

  // Input fields
  static TextStyle get input => s16;
  static TextStyle get hint => s14;
  static TextStyle get error => s12;
  static TextStyle get success => s12;

  // Captions
  static TextStyle get caption => s12;
  static TextStyle get captionSmall => s10;

  // Overline
  static TextStyle get overline => s10Medium;

  // ==================== HELPER METHODS ====================

  /// إنشاء TextStyle مخصص
  static TextStyle custom({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: defaultFont,
      fontSize: fontSize,
      fontWeight: fontWeight ?? regular,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// تطبيق لون على TextStyle
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// تطبيق وزن خط على TextStyle
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// تطبيق حجم خط على TextStyle
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
