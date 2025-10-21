/// نظام التعبيرات النمطية للتطبيق
/// Regular Expressions System for the Application
class AppRegx {
  AppRegx._internal();
  static final AppRegx _instance = AppRegx._internal();
  factory AppRegx() => _instance;

  // ==================== NUMERIC REGEX ====================

  /// تعبير نمطي للأرقام العشرية
  static final RegExp doubleNumRegEx = RegExp(r'(^\d*\.?\d*)');

  /// تعبير نمطي للأرقام الصحيحة
  static final RegExp intNumRegEx = RegExp(r'(^\d*)');

  // ==================== LANGUAGE REGEX ====================

  /// تعبير نمطي للنص العربي
  static final RegExp arabicRegEx = RegExp(r'[\u0600-\u06FF]');

  /// تعبير نمطي للنص الإنجليزي
  static final RegExp englishReg = RegExp(r"^[a-zA-Z]+$");

  // ==================== VALIDATION REGEX ====================

  /// تعبير نمطي للبريد الإلكتروني
  static final RegExp emailReg = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  /// تعبير نمطي لأرقام الهاتف السعودي
  static final RegExp phoneRegex = RegExp(
    r"^(?:\966)?(5|50|53|56|54|59|51|58|57)([0-9]{8})$",
  );

  // ==================== HELPER METHODS ====================

  /// التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    return emailReg.hasMatch(email);
  }

  /// التحقق من صحة رقم الهاتف السعودي
  static bool isValidSaudiPhone(String phone) {
    return phoneRegex.hasMatch(phone);
  }

  /// التحقق من وجود نص عربي
  static bool containsArabic(String text) {
    return arabicRegEx.hasMatch(text);
  }

  /// التحقق من وجود نص إنجليزي فقط
  static bool isEnglishOnly(String text) {
    return englishReg.hasMatch(text);
  }
}
