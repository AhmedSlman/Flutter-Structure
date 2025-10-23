import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shgrade/core/themes/app_colors.dart';
import 'package:shgrade/core/themes/text_styles.dart';

class CustomAddToCartButton extends StatelessWidget {
  const CustomAddToCartButton({
    super.key,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.isAdded = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.disabled = false,
  });

  final VoidCallback onTap;
  final String title;
  final bool isLoading;
  final bool isAdded;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on state
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;
      if (disabled) return Colors.grey.shade400;
      if (isAdded) return Colors.green.shade600;
      return AppColors.black;
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;
      if (disabled) return Colors.grey.shade600;
      return Colors.white;
    }

    Color getIconColor() {
      if (isAdded) return Colors.green.shade600;
      if (disabled) return Colors.grey.shade600;
      return AppColors.white;
    }

    return InkWell(
      onTap: (isLoading || isAdded || disabled) ? null : onTap,
      child: Container(
        height: 56.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            topLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(35.r),
            bottomLeft: Radius.circular(15.r),
          ),
          boxShadow: [
            BoxShadow(
              color: getBackgroundColor().withValues(alpha: 0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: isAdded ? Colors.white : AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    topLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(25.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              getIconColor(),
                            ),
                          ),
                        )
                      : icon != null
                      ? Icon(icon, size: 24.sp, color: getIconColor())
                      : Icon(
                          isAdded
                              ? Icons.check_circle_rounded
                              : Icons.shopping_cart_rounded,
                          size: 24.sp,
                          color: getIconColor(),
                        ),
                ),
              ),
              Spacer(flex: 3),
              Text(
                title,
                style: AppStyles.s14White(context).copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: getTextColor(),
                ),
              ),
              Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
