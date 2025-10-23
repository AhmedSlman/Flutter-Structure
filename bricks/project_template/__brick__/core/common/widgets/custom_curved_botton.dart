import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shgrade/core/themes/app_colors.dart';
import 'package:shgrade/core/themes/text_styles.dart';

class CustomCurvedBotton extends StatelessWidget {
  const CustomCurvedBotton({
    super.key,
    required this.onTap,
    required this.title,
    this.icon,
  });
  final void Function() onTap;
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.r),
            topLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(30.r),
            bottomLeft: Radius.circular(10.r),
          ),
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Container(
                height: 36.h,
                width: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.r),
                    topLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(30.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, size: 22.sp, color: AppColors.white)
                      : Icon(
                          Icons.shopping_bag_outlined,
                          size: 22.sp,
                          color: AppColors.white,
                        ),
                ),
              ),
              Spacer(flex: 3),
              Text(
                title,
                style: AppStyles.s14White(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
