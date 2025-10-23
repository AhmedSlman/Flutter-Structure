import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../localization/localization_helper.dart';

double tabletBreakpointGlobal = 600.0;
double desktopBreakpointGlobal = 720.0;

// Context Extensions
extension ContextExtensions on BuildContext {
  /// return screen size
  Size get size => MediaQuery.of(this).size;

  /// return screen width
  double get width => MediaQuery.of(this).size.width;

  /// return screen height
  double get height => MediaQuery.of(this).size.height;

  /// return screen devicePixelRatio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// returns brightness
  Brightness platformBrightness() => MediaQuery.of(this).platformBrightness;

  /// Return the height of status bar
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Return the height of navigation bar
  double get navigationBarHeight => MediaQuery.of(this).padding.bottom;

  /// Returns DefaultTextStyle.of(context)
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// Returns Form.of(context)
  FormState? get formState => Form.of(this);

  /// Returns Scaffold.of(context)
  ScaffoldState get scaffoldState => Scaffold.of(this);

  /// Returns Overlay.of(context)
  OverlayState? get overlayState => Overlay.of(this);

  /// Request focus to given FocusNode
  void requestFocus(FocusNode focus) {
    FocusScope.of(this).requestFocus(focus);
  }

  /// Request focus to given FocusNode
  void unFocus(FocusNode focus) => focus.unfocus();

  // /// Return the height of status bar
  // bool get isArabic => locale == const Locale('ar', 'EG');

  bool isPhone() => MediaQuery.of(this).size.width < tabletBreakpointGlobal;

  bool isTablet() =>
      MediaQuery.of(this).size.width < desktopBreakpointGlobal &&
      MediaQuery.of(this).size.width >= tabletBreakpointGlobal;

  bool isDesktop() => MediaQuery.of(this).size.width >= desktopBreakpointGlobal;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  TargetPlatform get platform => Theme.of(this).platform;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isIOS => platform == TargetPlatform.iOS;

  void openDrawer() => Scaffold.of(this).openDrawer();

  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  // ==================== LOCALIZATION EXTENSIONS ====================

  /// الحصول على النص المترجم
  String tr(String key, {List<String>? args, Map<String, String>? namedArgs}) {
    return key.tr(args: args, namedArgs: namedArgs);
  }

  /// التحقق من اللغة العربية
  bool get isArabic => EasyLocalization.isArabic;

  /// تغيير اللغة
  Future<void> changeLanguage(String languageName) async {
    await context.setLocale(Locale(languageName));
  }

  /// تبديل اللغة
  Future<void> toggleLanguage() async {
    final currentLocale = EasyLocalization.of(this)?.locale ?? const Locale('en');
    final newLocale = currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    await setLocale(newLocale);
  }

  // ==================== APP COLORS EXTENSIONS ====================

  /// الألوان الديناميكية
  Color get primaryColor => AppColors.primary(this);
  Color get secondaryColor => AppColors.secondary(this);
  Color get backgroundColor => AppColors.background(this);
  Color get onBackgroundColor => AppColors.onBackground(this);
  Color get surfaceColor => AppColors.surface(this);
  Color get onSurfaceColor => AppColors.onSurface(this);
  Color get surfaceVariantColor => AppColors.surfaceVariant(this);
  Color get onSurfaceVariantColor => AppColors.onSurfaceVariant(this);
  Color get borderColor => AppColors.border(this);
  Color get shadowColor => AppColors.shadow(this);

  /// الألوان الثابتة
  Color get successColor => AppColors.success;
  Color get errorColor => AppColors.error;
  Color get warningColor => AppColors.warning;
  Color get infoColor => AppColors.info;

  // ==================== APP STYLES EXTENSIONS ====================

  /// أنماط النصوص الشائعة
  TextStyle get headerStyle => AppStyles.header.copyWith(color: onSurfaceColor);
  TextStyle get subHeaderStyle => AppStyles.subHeader.copyWith(color: onSurfaceColor);
  TextStyle get sectionTitleStyle => AppStyles.sectionTitle.copyWith(color: onSurfaceColor);
  TextStyle get bodyStyle => AppStyles.body.copyWith(color: onSurfaceColor);
  TextStyle get bodySmallStyle => AppStyles.bodySmall.copyWith(color: onSurfaceColor);
  TextStyle get bodyLargeStyle => AppStyles.bodyLarge.copyWith(color: onSurfaceColor);
  TextStyle get labelStyle => AppStyles.label.copyWith(color: onSurfaceColor);
  TextStyle get labelSmallStyle => AppStyles.labelSmall.copyWith(color: onSurfaceColor);
  TextStyle get labelLargeStyle => AppStyles.labelLarge.copyWith(color: onSurfaceColor);
  TextStyle get buttonStyle => AppStyles.button.copyWith(color: onSurfaceColor);
  TextStyle get buttonSmallStyle => AppStyles.buttonSmall.copyWith(color: onSurfaceColor);
  TextStyle get buttonLargeStyle => AppStyles.buttonLarge.copyWith(color: onSurfaceColor);
  TextStyle get inputStyle => AppStyles.input.copyWith(color: onSurfaceColor);
  TextStyle get hintStyle => AppStyles.hint.copyWith(color: onSurfaceColor);
  TextStyle get errorStyle => AppStyles.error.copyWith(color: errorColor);
  TextStyle get successStyle => AppStyles.success.copyWith(color: successColor);
  TextStyle get captionStyle => AppStyles.caption.copyWith(color: onSurfaceColor);
  TextStyle get captionSmallStyle => AppStyles.captionSmall.copyWith(color: onSurfaceColor);
  TextStyle get overlineStyle => AppStyles.overline.copyWith(color: onSurfaceColor);

  // ==================== HELPER METHODS ====================

  /// إنشاء TextStyle مخصص مع الألوان الحالية
  TextStyle customTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return AppStyles.custom(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? onSurfaceColor,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// إنشاء TextStyle مع لون مخصص
  TextStyle textStyleWithColor(TextStyle style, Color color) {
    return AppStyles.withColor(style, color);
  }

  /// إنشاء TextStyle مع وزن خط مخصص
  TextStyle textStyleWithWeight(TextStyle style, FontWeight weight) {
    return AppStyles.withWeight(style, weight);
  }

  /// إنشاء TextStyle مع حجم خط مخصص
  TextStyle textStyleWithSize(TextStyle style, double size) {
    return AppStyles.withSize(style, size);
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  // ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;
  Color get primaryColor => theme.colorScheme.primary;
  Color get primaryFontColor => theme.colorScheme.primary;
  Color get background => theme.colorScheme.background;
  Color get secondaryColor => theme.colorScheme.secondary;

  /// only found in one place in login screen
  Color get loginTextColor => theme.colorScheme.onTertiary;
  Color get formFieldColor => theme.colorScheme.surface;
  Color get tertiaryColor => theme.colorScheme.tertiary;

  Color get primaryCardColor => theme.cardColor;
  Color get secondaryCardColor => theme.cardTheme.color!;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  Color get bottomSheetBackground => theme.bottomSheetTheme.backgroundColor!;

  Color get buttonColor => theme.colorScheme.secondary;
  Color get errorColor => theme.colorScheme.error;
  Color get errorContainerColor => theme.colorScheme.errorContainer;

  Color get fillColor => theme.inputDecorationTheme.fillColor!;
  Color get hintColor => theme.inputDecorationTheme.hintStyle!.color!;
  Color get borderColor => theme.inputDecorationTheme.border!.borderSide.color;

  Color get bottomNavBarSelectedItemColor =>
      theme.bottomNavigationBarTheme.selectedItemColor!;

  TextStyle? get hintTextStyle => theme.inputDecorationTheme.hintStyle;

  IconThemeData? get iconTheme => theme.appBarTheme.iconTheme;

  // TextTheme
  TextTheme get textTheme => theme.textTheme;
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}
