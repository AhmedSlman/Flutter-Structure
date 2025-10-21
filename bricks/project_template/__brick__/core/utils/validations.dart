import '../localization/localization_helper.dart';
import 'regx.dart';

/// نظام التحقق من صحة البيانات
/// Data Validation System
class Validation {
  Validation._();

  // ==================== BASIC VALIDATIONS ====================

  /// التحقق من الحقل المطلوب
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationHelper.tr('requiredField');
    }
    return null;
  }

  /// التحقق من الحقل المطلوب مع رسالة مخصصة
  static String? requiredFieldWithMessage(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  // ==================== PHONE VALIDATIONS ====================

  /// التحقق من رقم الهاتف السعودي
  static String? phoneValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationHelper.tr('requiredPhone');
    }

    if (!AppRegx.isValidSaudiPhone(value.trim())) {
      return LocalizationHelper.tr('phoneDoseNotMatch');
    }

    return null;
  }

  /// التحقق من صحة رقم الهاتف السعودي (بدون رسالة خطأ)
  static bool isValidSaudiPhoneNumber(String input) {
    return AppRegx.isValidSaudiPhone(input);
  }

  // ==================== EMAIL VALIDATIONS ====================

  /// التحقق من البريد الإلكتروني
  static String? emailValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationHelper.tr('requiredEmail');
    }

    if (!AppRegx.isValidEmail(value.trim())) {
      return LocalizationHelper.tr('wrongEmailValidation');
    }

    return null;
  }

  // ==================== PASSWORD VALIDATIONS ====================

  /// التحقق من كلمة المرور
  static String? passwordValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationHelper.tr('requiredPassword');
    }

    if (value.trim().length < 8) {
      return LocalizationHelper.tr('smallPassword');
    }

    return null;
  }

  /// التحقق من تأكيد كلمة المرور
  static String? confirmPasswordValidation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return LocalizationHelper.tr('confirmPassword');
    }

    if (password != value) {
      return LocalizationHelper.tr('passwordNotMatch');
    }

    return null;
  }

  // ==================== LENGTH VALIDATIONS ====================

  /// التحقق من الحد الأدنى للطول
  static String? minLengthValidation(String? value, int minLength) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationHelper.tr('requiredField');
    }

    if (value.trim().length < minLength) {
      return 'يجب أن يكون النص ${minLength} أحرف على الأقل';
    }

    return null;
  }

  /// التحقق من الحد الأقصى للطول
  static String? maxLengthValidation(String? value, int maxLength) {
    if (value != null && value.trim().length > maxLength) {
      return 'يجب أن يكون النص ${maxLength} أحرف على الأكثر';
    }

    return null;
  }

  // ==================== COMBINED VALIDATIONS ====================

  /// التحقق من الحقل المطلوب مع الحد الأدنى للطول
  static String? requiredWithMinLength(String? value, int minLength) {
    final requiredError = requiredField(value);
    if (requiredError != null) return requiredError;

    return minLengthValidation(value, minLength);
  }

  /// التحقق من البريد الإلكتروني مع الحقل المطلوب
  static String? requiredEmailValidation(String? value) {
    final requiredError = requiredField(value);
    if (requiredError != null) return requiredError;

    return emailValidation(value);
  }

  /// التحقق من رقم الهاتف مع الحقل المطلوب
  static String? requiredPhoneValidation(String? value) {
    final requiredError = requiredField(value);
    if (requiredError != null) return requiredError;

    return phoneValidation(value);
  }
}
