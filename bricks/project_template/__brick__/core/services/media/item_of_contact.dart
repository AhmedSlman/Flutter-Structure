import 'package:flutter/material.dart';

import '../../../shared/widgets/customtext.dart';
import '../../extensions/context_extensions.dart';
import '../../localization/localization_helper.dart';

class ItemOfContact extends StatelessWidget {
  final void Function()? onTap;
  final bool choose, isImage;
  final String? title;
  const ItemOfContact({
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
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            decoration: BoxDecoration(
              color: choose ? context.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: choose
                    ? Colors.transparent
                    : Colors.grey.withOpacity(.4),
              ),
            ),
            child: Row(
              children: [
                CustomText(
                  title ?? '', 
                  fontSize: 17, 
                  weight: FontWeight.w400,
                  color: LocalizationHelper.isArabic ? Colors.white : Colors.black,
                ),
                const Spacer(),
                choose
                    ? Icon(
                        Icons.camera_alt_outlined,
                        color: context.primaryColor,
                      )
                    : Icon(Icons.image_outlined, color: context.primaryColor),
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            height: 70,
            decoration: BoxDecoration(
              color: choose ? context.secondaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: choose
                    ? Colors.transparent
                    : Colors.grey.withOpacity(.4),
              ),
            ),
            child: Row(
              children: [
                CustomText(
                  title ?? '', 
                  fontSize: 17,
                  color: LocalizationHelper.isArabic ? Colors.white : Colors.black,
                ),
                const Spacer(),
                choose
                    ? Image.asset(
                        'check-circle',
                        height: 30,
                        width: 30,
                        color: context.primaryColor,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: context.primaryColor),
                          shape: BoxShape.circle,
                        ),
                      ),
              ],
            ),
          );
  }
}
