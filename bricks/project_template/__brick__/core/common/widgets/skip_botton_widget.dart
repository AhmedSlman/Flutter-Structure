import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shgrade/core/router/route_names.dart';
import 'package:shgrade/core/themes/app_colors.dart';
import 'package:shgrade/core/themes/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class SkipBotton extends StatelessWidget {
  const SkipBotton({
    super.key,
    required this.color,
    required this.iconColor,
    this.onTap,
  });
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.go(RouterNames.bottomNavBar),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          height: 25.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, color: iconColor, size: 12.sp),
              SizedBox(width: 5.w),
              Text(
                "intro_skip".tr(),
                style: AppStyles.s12(context).copyWith(color: iconColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
