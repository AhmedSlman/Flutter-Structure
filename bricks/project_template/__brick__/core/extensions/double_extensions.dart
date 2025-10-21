import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Double Extensions
extension DoubleExtensions on double? {
  /// Validate given double is not null and returns given value if null.
  double validate({double value = 0.0}) => this ?? value;

  /// 100.0.isBetween(50.0, 150.0) // true;
  bool isBetween(num first, num second) {
    final lower = min(first, second);
    final upper = max(first, second);
    // ignore: unnecessary_this
    return this.validate() >= lower && this.validate() <= upper;
  }

  /// Returns Size
  Size get size => Size(this!, this!);

  /// Leaves given height of space
  // Widget get height => this!.verticalSpace;
  Widget get height => SizedBox(
        height: this,
      );

  /// Leaves given width of space
  // Widget get width => this!.horizontalSpace;
  Widget get width => SizedBox(
        width: this,
      );

  /// Converts the value of this [double] to radians.
  ///
  /// Returns the value of this [double] in radians by multiplying it with the conversion factor `pi / 180.0`.
  double get toRadians => validate() * (pi / 180.0);

  EdgeInsets get edgeInsetsHorizontal =>
      EdgeInsets.symmetric(horizontal: validate());

  EdgeInsets get edgeInsetsVertical =>
      EdgeInsets.symmetric(vertical: validate());

  EdgeInsets get edgeInsetsAll => EdgeInsets.all(validate());

  EdgeInsets get edgeInsetsOnlyTop => EdgeInsets.only(top: validate());

  EdgeInsets get edgeInsetsOnlyBottom => EdgeInsets.only(bottom: validate());

  EdgeInsets get edgeInsetsOnlyLeft => EdgeInsets.only(left: validate());

  EdgeInsets get edgeInsetsOnlyRight => EdgeInsets.only(right: validate());

  BorderRadius get borderRadius => BorderRadius.circular(validate());

  BorderRadius get leftBorderRadius => BorderRadius.only(
        topLeft: Radius.circular(validate()),
        bottomLeft: Radius.circular(validate()),
      );

  BorderRadius get rightBorderRadius => BorderRadius.only(
        topRight: Radius.circular(validate()),
        bottomRight: Radius.circular(validate()),
      );

  BorderRadius get topBorderRadius => BorderRadius.only(
        topLeft: Radius.circular(validate()),
        topRight: Radius.circular(validate()),
      );

  BorderRadius get bottomBorderRadius => BorderRadius.only(
        bottomLeft: Radius.circular(validate()),
        bottomRight: Radius.circular(validate()),
      );
}
