import 'package:flutter/material.dart';
import '../../core/extensions/all_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum TextStyleEnum {
  normal,
  title,
  caption,
}

class CustomText extends StatelessWidget {
  TextStyle getTextStyle(TextStyleEnum textStyleEnum,
      {Color? color,
      double? fontSize,
      double? height,
      String? fontFamily,
      TextOverflow? overflow,
      TextDecoration? decoration,
      FontWeight? weight}) {
    switch (textStyleEnum) {
      case TextStyleEnum.title:
        return AppStyles.header.copyWith(
            decoration: decoration,
            color: color ?? AppColors.textPrimary,
            height: height,
            fontWeight: weight,
            fontSize: fontSize,
            overflow: overflow ?? TextOverflow.visible,
            fontFamily: fontFamily);
      case TextStyleEnum.caption:
        return AppStyles.caption.copyWith(
            decoration: decoration,
            color: color ?? AppColors.textSecondary,
            fontWeight: weight,
            height: height,
            fontSize: fontSize,
            overflow: overflow ?? TextOverflow.visible,
            fontFamily: fontFamily);

      default:
        return AppStyles.body.copyWith(
            decoration: decoration,
            color: color ?? AppColors.textPrimary,
            height: height,
            fontWeight: weight,
            fontSize: fontSize,
            overflow: overflow ?? TextOverflow.visible,
            fontFamily: fontFamily);
    }
  }

  const CustomText(
    this.text, {
    Key? key,
    this.textStyleEnum,
    this.color,
    this.fontSize,
    this.weight,
    this.fontFamily,
    this.align,
    this.height,
    this.style,
    this.decoration,
    this.overflow,
    this.maxLine,
  }) : super(key: key);
  final String text;
  final TextStyleEnum? textStyleEnum;
  final Color? color;
  final double? fontSize;
  final double? height;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final TextAlign? align;
  final FontWeight? weight;
  final TextStyle? style;
  final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.start,
      maxLines: maxLine,
      style: style ??
          getTextStyle(textStyleEnum ?? TextStyleEnum.normal,
              color: color,
              height: height,
              fontSize: fontSize,
              fontFamily: fontFamily ?? 'Roboto',
              overflow: overflow,
              decoration: decoration,
              weight: weight),
    );
  }
}
