import 'package:flutter/material.dart';
import '../../core/extensions/all_extensions.dart';

class TextWidget extends StatelessWidget {
  final String? title;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool isUnderLine;

  // ignore: use_key_in_widget_constructors
  const TextWidget(this.title,
      {this.fontSize,
      this.fontWeight,
      this.fontFamily,
      this.maxLines = 2,
      this.color,
      this.textAlign,
      this.isUnderLine = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Sans',
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight,
        decoration: isUnderLine ? TextDecoration.underline : null,
        height: 1.2,
        // color: color ?? Theme.of(context).textTheme.bodyText1!.color,
        color: color ?? context.colorScheme.primary,
      ),
      textAlign: textAlign,
    );
  }
}
