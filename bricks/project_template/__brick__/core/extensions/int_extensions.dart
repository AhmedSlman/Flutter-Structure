import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../localization/localization_helper.dart';

// int Extensions
extension IntExtensions on int? {
  /// Validate given int is not null and returns given value if null.
  int validate({int value = 0}) => this ?? value;

  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble());

  /// HTTP status code
  bool isSuccessful() => this! >= 200 && this! <= 206;

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: validate());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: validate());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: validate());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: validate());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: validate());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: validate());

  /// Returns if a number is between `first` and `second`
  /// ```dart
  /// 100.isBetween(50, 150) // true;
  /// 100.isBetween(100, 100) // true;
  /// ```
  bool isBetween(num first, num second) {
    if (first <= second) {
      return validate() >= first && validate() <= second;
    } else {
      return validate() >= second && validate() <= first;
    }
  }

  /// Returns Size
  Size get size => Size(this!.toDouble(), this!.toDouble());

  // return suffix (th,st,nd,rd) of the given month day number
  String toMonthDaySuffix() {
    if (!(this! >= 1 && this! <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (this! >= 11 && this! <= 13) {
      return '$this th';
    }

    switch (this! % 10) {
      case 1:
        return '$this st';
      case 2:
        return '$this nd';
      case 3:
        return '$this rd';
      default:
        return '$this th';
    }
  }

  // returns month name from the given int
  String toMonthName({bool isHalfName = false}) {
    String status = '';
    if (!(this! >= 1 && this! <= 12)) {
      throw Exception('Invalid day of month');
    }
    if (this == 1) {
      return status = isHalfName ? 'Jan' : 'January';
    } else if (this == 2) {
      return status = isHalfName ? 'Feb' : 'February';
    } else if (this == 3) {
      return status = isHalfName ? 'Mar' : 'March';
    } else if (this == 4) {
      return status = isHalfName ? 'Apr' : 'April';
    } else if (this == 5) {
      return status = isHalfName ? 'May' : 'May';
    } else if (this == 6) {
      return status = isHalfName ? 'Jun' : 'June';
    } else if (this == 7) {
      return status = isHalfName ? 'Jul' : 'July';
    } else if (this == 8) {
      return status = isHalfName ? 'Aug' : 'August';
    } else if (this == 9) {
      return status = isHalfName ? 'Sept' : 'September';
    } else if (this == 10) {
      return status = isHalfName ? 'Oct' : 'October';
    } else if (this == 11) {
      return status = isHalfName ? 'Nov' : 'November';
    } else if (this == 12) {
      return status = isHalfName ? 'Dec' : 'December';
    }
    return status;
  }

  // returns WeekDay from the given int
  String toWeekDay({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 7)) {
      throw Exception('Invalid day of month');
    }
    String weekName = '';

    if (this == 1) {
      return weekName = isHalfName ? "Mon" : "Monday";
    } else if (this == 2) {
      return weekName = isHalfName ? "Tue" : "Tuesday";
    } else if (this == 3) {
      return weekName = isHalfName ? "Wed" : "Wednesday";
    } else if (this == 4) {
      return weekName = isHalfName ? "Thu" : "Thursday";
    } else if (this == 5) {
      return weekName = isHalfName ? "Fri" : "Friday";
    } else if (this == 6) {
      return weekName = isHalfName ? "Sat" : "Saturday";
    } else if (this == 7) {
      return weekName = isHalfName ? "Sun" : "Sunday";
    }
    return weekName;
  }

  // ==================== LOCALIZATION INTEGRATION ====================

  /// تنسيق اليوم مع الترجمة
  String toWeekDayWithLocalization({bool isHalfName = false}) {
    if (LocalizationHelper.isArabic) {
      return toWeekDayArabic(isHalfName: isHalfName);
    } else {
      return toWeekDayEnglish(isHalfName: isHalfName);
    }
  }

  /// تنسيق اليوم باللغة العربية
  String toWeekDayArabic({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 7)) {
      throw Exception('Invalid day of month');
    }

    if (this == 1) {
      return isHalfName ? "الاثنين" : "الاثنين";
    } else if (this == 2) {
      return isHalfName ? "الثلاثاء" : "الثلاثاء";
    } else if (this == 3) {
      return isHalfName ? "الأربعاء" : "الأربعاء";
    } else if (this == 4) {
      return isHalfName ? "الخميس" : "الخميس";
    } else if (this == 5) {
      return isHalfName ? "الجمعة" : "الجمعة";
    } else if (this == 6) {
      return isHalfName ? "السبت" : "السبت";
    } else if (this == 7) {
      return isHalfName ? "الأحد" : "الأحد";
    }
    return '';
  }

  /// تنسيق اليوم باللغة الإنجليزية
  String toWeekDayEnglish({bool isHalfName = false}) {
    return toWeekDay(isHalfName: isHalfName);
  }

  /// تنسيق الشهر مع الترجمة
  String toMonthNameWithLocalization({bool isHalfName = false}) {
    if (LocalizationHelper.isArabic) {
      return toMonthNameArabic(isHalfName: isHalfName);
    } else {
      return toMonthNameEnglish(isHalfName: isHalfName);
    }
  }

  /// تنسيق الشهر باللغة العربية
  String toMonthNameArabic({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 12)) {
      throw Exception('Invalid day of month');
    }

    if (this == 1) {
      return isHalfName ? "يناير" : "يناير";
    } else if (this == 2) {
      return isHalfName ? "فبراير" : "فبراير";
    } else if (this == 3) {
      return isHalfName ? "مارس" : "مارس";
    } else if (this == 4) {
      return isHalfName ? "أبريل" : "أبريل";
    } else if (this == 5) {
      return isHalfName ? "مايو" : "مايو";
    } else if (this == 6) {
      return isHalfName ? "يونيو" : "يونيو";
    } else if (this == 7) {
      return isHalfName ? "يوليو" : "يوليو";
    } else if (this == 8) {
      return isHalfName ? "أغسطس" : "أغسطس";
    } else if (this == 9) {
      return isHalfName ? "سبتمبر" : "سبتمبر";
    } else if (this == 10) {
      return isHalfName ? "أكتوبر" : "أكتوبر";
    } else if (this == 11) {
      return isHalfName ? "نوفمبر" : "نوفمبر";
    } else if (this == 12) {
      return isHalfName ? "ديسمبر" : "ديسمبر";
    }
    return '';
  }

  /// تنسيق الشهر باللغة الإنجليزية
  String toMonthNameEnglish({bool isHalfName = false}) {
    return toMonthName(isHalfName: isHalfName);
  }

  // ==================== APP COLORS INTEGRATION ====================

  /// إنشاء Container مع لون AppColors
  Widget containerWithPrimaryColor(BuildContext context) {
    return Container(
      width: validate().toDouble(),
      height: validate().toDouble(),
      color: AppColors.primary(context),
    );
  }

  Widget containerWithSecondaryColor(BuildContext context) {
    return Container(
      width: validate().toDouble(),
      height: validate().toDouble(),
      color: AppColors.secondary(context),
    );
  }

  Widget containerWithBackgroundColor(BuildContext context) {
    return Container(
      width: validate().toDouble(),
      height: validate().toDouble(),
      color: AppColors.background(context),
    );
  }

  Widget containerWithSurfaceColor(BuildContext context) {
    return Container(
      width: validate().toDouble(),
      height: validate().toDouble(),
      color: AppColors.surface(context),
    );
  }

  // ==================== APP STYLES INTEGRATION ====================

  /// إنشاء Text مع AppStyles
  Widget textWithStyle(BuildContext context, String text, {TextStyle? style}) {
    return Text(
      text,
      style: style ?? AppStyles.body.copyWith(fontSize: validate().toDouble()),
    );
  }

  Widget textWithHeaderStyle(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.header.copyWith(fontSize: validate().toDouble()),
    );
  }

  Widget textWithSubHeaderStyle(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.subHeader.copyWith(fontSize: validate().toDouble()),
    );
  }

  Widget textWithBodyStyle(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.body.copyWith(fontSize: validate().toDouble()),
    );
  }

  Widget textWithButtonStyle(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.button.copyWith(fontSize: validate().toDouble()),
    );
  }
}
