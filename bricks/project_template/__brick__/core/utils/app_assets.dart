import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// نظام إدارة الأصول البسيط - Simple Assets Management
/// استدعي الصور والـ SVG بسهولة
class AppAssets {
  AppAssets._();

  // ==================== IMAGES ====================

  /// الصور الأساسية
  static const String logo = 'assets/images/logo.png';
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String error = 'assets/images/error.png';
  static const String success = 'assets/images/success.png';
  static const String loading = 'assets/images/loading.png';

  /// صور الخلفيات
  static const String background1 = 'assets/images/background_1.png';
  static const String background2 = 'assets/images/background_2.png';
  static const String background3 = 'assets/images/background_3.png';

  /// صور المستخدمين
  static const String userDefault = 'assets/images/user_default.png';
  static const String userAvatar = 'assets/images/user_avatar.png';

  // ==================== SVG ICONS ====================

  /// الأيقونات الأساسية
  static const String home = 'assets/icons/home.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String settings = 'assets/icons/settings.svg';
  static const String search = 'assets/icons/search.svg';
  static const String notification = 'assets/icons/notification.svg';

  /// أيقونات التنقل
  static const String back = 'assets/icons/back.svg';
  static const String forward = 'assets/icons/forward.svg';
  static const String close = 'assets/icons/close.svg';
  static const String menu = 'assets/icons/menu.svg';

  /// أيقونات الحالة
  static const String successIcon = 'assets/icons/success.svg';
  static const String errorIcon = 'assets/icons/error.svg';
  static const String warning = 'assets/icons/warning.svg';
  static const String info = 'assets/icons/info.svg';

  /// أيقونات الوسائط
  static const String camera = 'assets/icons/camera.svg';
  static const String gallery = 'assets/icons/gallery.svg';
  static const String video = 'assets/icons/video.svg';
  static const String audio = 'assets/icons/audio.svg';

  /// أيقونات التواصل
  static const String phone = 'assets/icons/phone.svg';
  static const String email = 'assets/icons/email.svg';
  static const String message = 'assets/icons/message.svg';
  static const String location = 'assets/icons/location.svg';

  // ==================== HELPER METHODS ====================

  /// إنشاء صورة
  static Widget image(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  /// إنشاء SVG
  static Widget svg(
    String path, {
    double? width,
    double? height,
    Color? color,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  /// إنشاء أيقونة
  static Widget icon(String path, {double size = 24.0, Color? color}) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  /// الحصول على اللوجو حسب الثيم
  static String getLogo(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? logoDark : logo;
  }

  // ==================== QUICK ACCESS ====================




}
  /// الوصول السريع للصور
  abstract class ImagesAssets {
    static const String logo = AppAssets.logo;
    static const String logoDark = AppAssets.logoDark;
    static const String placeholder = AppAssets.placeholder;
    static const String error = AppAssets.error;
    static const String success = AppAssets.success;
    static const String loading = AppAssets.loading;
  }  /// الوصول السريع للأيقونات
  abstract class IconsAssets {
    static const String home = AppAssets.home;
    static const String profile = AppAssets.profile;
    static const String settings = AppAssets.settings;
    static const String search = AppAssets.search;
    static const String notification = AppAssets.notification;
    static const String back = AppAssets.back;
    static const String forward = AppAssets.forward;
    static const String close = AppAssets.close;
    static const String menu = AppAssets.menu;
  }