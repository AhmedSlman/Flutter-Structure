import 'package:flutter/material.dart';

import '../resources/font_manager.dart';

extension TextStyleEx on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);

  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);

  TextStyle get s8 => copyWith(fontSize: FontSize.s8);

  TextStyle get s10 => copyWith(fontSize: FontSize.s10);

  TextStyle get s11 => copyWith(fontSize: FontSize.s11);

  TextStyle get s12 => copyWith(fontSize: FontSize.s12);

  TextStyle get s14 => copyWith(fontSize: FontSize.s14);

  TextStyle get s16 => copyWith(fontSize: FontSize.s16);

  TextStyle get s18 => copyWith(fontSize: FontSize.s18);

  TextStyle get s20 => copyWith(fontSize: FontSize.s20);

  TextStyle get s22 => copyWith(fontSize: FontSize.s22);

  TextStyle get s24 => copyWith(fontSize: FontSize.s24);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle get overline => copyWith(decoration: TextDecoration.overline);

  TextStyle get ellipsis => copyWith(overflow: TextOverflow.ellipsis);

  TextStyle setColor(Color color) => copyWith(color: color);

  TextStyle setFontSize(double size) => copyWith(fontSize: size);

  TextStyle setFontWeight(FontWeight weight) => copyWith(fontWeight: weight);

  TextStyle setHeight(double value) => copyWith(height: value);

  TextStyle setLetterSpacing(double value) => copyWith(letterSpacing: value);

  TextStyle setFontStyle(FontStyle style) => copyWith(fontStyle: style);

  TextStyle setDecoration(TextDecoration decoration) => copyWith(decoration: decoration);

  TextStyle setDecorationColor(Color color) => copyWith(decorationColor: color);

  TextStyle setDecorationStyle(TextDecorationStyle style) => copyWith(decorationStyle: style);

  TextStyle setWordSpacing(double value) => copyWith(wordSpacing: value);

  TextStyle setShadows(List<Shadow> shadows) => copyWith(shadows: shadows);

  TextStyle setForeground(Color color) => copyWith(foreground: Paint()..color = color);

  TextStyle setBackground(Color color) => copyWith(background: Paint()..color = color);

  TextStyle setFontFamily(String? family) => copyWith(fontFamily: family);

  TextStyle setPackage(String? package) => copyWith(package: package);

  TextStyle setHeightPercent(double value) => copyWith(height: value);
}
