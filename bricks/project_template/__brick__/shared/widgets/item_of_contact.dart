import 'package:flutter/material.dart';
import '../../core/extensions/all_extensions.dart';

import 'customtext.dart';

class ItemOfContact extends StatelessWidget {
  final void Function()? onTap;
  final bool choose, isImage;
  final String? title;
  ItemOfContact({
    super.key,
    this.onTap,
    this.choose = false,
    this.title,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return (isImage)
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            // height: 60.h,
            decoration: BoxDecoration(
              color: choose ? context.colorScheme.secondary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              /*   border: Border.all(
                    color: choose
                        ? Colors.transparent
                        : AppColors.borderMainColor) */
            ),
            child: Row(
              children: [
                CustomText(
                  title ?? '',
                  fontSize: 17,
                  weight: FontWeight.w400,
                ),
                const Spacer(),
                choose
                    ? Icon(Icons.camera_alt_outlined, color: context.colorScheme.primary)
                    : Icon(Icons.image_outlined, color: context.colorScheme.primary)
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            height: 70,
            decoration: BoxDecoration(
              // color: choose ? AppColors.secondary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              /*  border: Border.all(
                    color: choose
                        ? Colors.transparent
                        : AppColors.borderMainColor) */
            ),
            child: Row(
              children: [
                CustomText(
                  title ?? '',
                  fontSize: 17,
                ),
                const Spacer(),
                Container(
                  height: 25,
                  width: 25,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: context.colorScheme.primary),
                      shape: BoxShape.circle),
                  child: choose
                      ? Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              border: Border.all(color: context.colorScheme.primary),
                              shape: BoxShape.circle),
                        )
                      : null,
                )
                /*  : Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.primary),
                            shape: BoxShape.circle),
                      ) */
              ],
            ),
          );
  }
}
