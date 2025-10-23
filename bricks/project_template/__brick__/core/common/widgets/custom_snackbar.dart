import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shgrade/core/themes/app_colors.dart';
import 'package:shgrade/core/themes/text_styles.dart';
import 'package:another_flushbar/flushbar.dart';

class CustomSnackBar {
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green.shade600,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_rounded,
      iconColor: Colors.red.shade600,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_rounded,
      iconColor: AppColors.primary,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.orange.shade600,
      icon: Icons.warning_rounded,
      iconColor: Colors.orange.shade600,
      duration: duration,
    );
  }

  static void showAddToCartSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onCartTap,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.shopping_cart_checkout_rounded,
      iconColor: Colors.green.shade600,
      duration: duration,
      actionLabel: 'عرض السلة',
      onAction: onCartTap,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: backgroundColor,
      margin: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 18.h),
      borderRadius: BorderRadius.circular(18.r),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
      icon: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(10.w),
        child: Icon(icon, color: iconColor, size: 22.sp),
      ),
      messageText: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.s16(context).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          height: 1,
          fontSize: 14.sp,
        ),
      ),
      duration: duration,
      animationDuration: Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      mainButton: (actionLabel != null && onAction != null)
          ? TextButton(
              onPressed: () {
                onAction();
              },
              child: Text(
                actionLabel,
                style: AppStyles.s14Black(
                  context,
                ).copyWith(color: Colors.white),
              ),
            )
          : null,
    ).show(context);
  }
}
