import 'package:intl/intl.dart';
import '../localization/localization_helper.dart';

extension DateTimeExtensions on DateTime? {
  DateTime get validate {
    if (this == null) {
      return DateTime.now();
    }
    return this!;
  }

  String format({String format = 'dd/MM/yyyy', String locale = 'en'}) {
    return DateFormat(format, locale).format(validate);
  }

  String formatTime({String format = 'hh:mm a', String locale = 'en'}) {
    return DateFormat(format, locale).format(validate);
  }

  bool get isNull => this == null;

  // ==================== LOCALIZATION INTEGRATION ====================

  /// تنسيق التاريخ مع الترجمة
  String formatWithLocalization({String format = 'dd/MM/yyyy'}) {
    final locale = LocalizationHelper.isArabic ? 'ar' : 'en';
    return DateFormat(format, locale).format(validate);
  }

  /// تنسيق الوقت مع الترجمة
  String formatTimeWithLocalization({String format = 'hh:mm a'}) {
    final locale = LocalizationHelper.isArabic ? 'ar' : 'en';
    return DateFormat(format, locale).format(validate);
  }

  /// تنسيق التاريخ باللغة العربية
  String formatArabic({String format = 'dd/MM/yyyy'}) {
    return DateFormat(format, 'ar').format(validate);
  }

  /// تنسيق التاريخ باللغة الإنجليزية
  String formatEnglish({String format = 'dd/MM/yyyy'}) {
    return DateFormat(format, 'en').format(validate);
  }
}

extension DurationExtensions on Duration {
  String get formatDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// تنسيق المدة مع الترجمة
  String formatDurationWithLocalization() {
    if (LocalizationHelper.isArabic) {
      return formatDurationArabic();
    } else {
      return formatDurationEnglish();
    }
  }

  /// تنسيق المدة باللغة العربية
  String formatDurationArabic() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}س ${minutes}د ${seconds}ث';
    } else if (minutes > 0) {
      return '${minutes}د ${seconds}ث';
    } else {
      return '${seconds}ث';
    }
  }

  /// تنسيق المدة باللغة الإنجليزية
  String formatDurationEnglish() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
