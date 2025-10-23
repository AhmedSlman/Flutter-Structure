import 'package:flutter/material.dart';
import '../../shared/widgets/text_widget.dart';
import '../../core/extensions/all_extensions.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final String? fontFamily;
  final double width, height, radius;
  final Widget? child;
  final Gradient? gradient;
  final double? fontSize;
  final FontWeight? fontweight;
  final Alignment? alignment;
  final Color? textColor, buttonColor, borderColor;
  final void Function()? onTap;
  final bool withBorder;

  const ButtonWidget({
    super.key,
    this.gradient,
    this.title = "OK",
    this.width = double.infinity,
    this.height = 48.0,
    this.onTap,
    this.fontFamily,
    this.child,
    this.fontSize,
    this.fontweight,
    this.alignment,
    this.textColor = Colors.white,
    this.buttonColor,
    this.borderColor,
    this.withBorder = false,
    this.radius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              buttonColor ?? context.primaryColor),
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shadowColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: withBorder
                  ? BorderSide(color: borderColor ?? context.primaryColor)
                  : const BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        child: child ??
            TextWidget(
              title,
              fontWeight: fontweight ?? FontWeight.w400,
              fontSize: fontSize ?? 16,
              fontFamily: fontFamily,
              color: textColor ?? Colors.white,
            ),
      ),
    );
  }
}

class TextButtonWidget extends StatelessWidget {
  TextButtonWidget({
    super.key,
    required this.function,
    required this.text,
    this.fontweight,
    this.color,
    this.size,
    this.fontFamily,
  });
  final Function function;
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? fontweight;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        function();
      },
      child: TextWidget(
        text,
        fontWeight: fontweight ?? FontWeight.w500,
        fontFamily: fontFamily ?? "Almarai",
        fontSize: size ?? 16,
        color: color ?? context.primaryColor,
        //  style: TextStyle(color: AppColors.secondary),
      ),
      // style: TextButton.styleFrom(
      //   elevation: 0,
      //   textStyle: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     fontSize: (width <= 550) ? 13 : 17,
      //   ),
      // ),
    );
  }
}
