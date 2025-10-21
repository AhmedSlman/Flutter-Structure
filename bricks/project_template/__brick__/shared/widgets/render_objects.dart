import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomBox extends SingleChildRenderObjectWidget {
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  const CustomBox({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.borderRadius,
    this.onTap,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomBox(
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context,
      covariant RenderCustomBox renderObject,
      ) {
    renderObject
      ..width = width
      ..height = height
      ..color = color
      ..borderRadius = borderRadius
      ..onTap = onTap;
  }
}

class RenderCustomBox extends RenderBox {
  double _width;
  double _height;
  Color _color;
  BorderRadius _borderRadius;
  VoidCallback? _onTap;

  RenderCustomBox({
    required double width,
    required double height,
    required Color color,
    required BorderRadius borderRadius,
    VoidCallback? onTap,
  })  : _width = width,
        _height = height,
        _color = color,
        _borderRadius = borderRadius,
        _onTap = onTap;

  // @override
  // bool get sizedByParent => true;

  // @override
  // void performLayout() {
  //   size = Size(_width, _height);
  //   if (child != null) {
  //     child!.layout(constraints, parentUsesSize: true);
  //   }
  // }

  ///////

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    if (event is PointerDownEvent && _onTap != null) {
      _onTap!();
    }
  }

  set onTap(VoidCallback? value) {
    if (_onTap != value) {
      _onTap = value;
      markNeedsPaint();
    }
  }

  /////

  @override
  void performLayout() {
    size = Size(_width, _height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Paint paint = Paint()..color = _color;
    final Rect rect = offset & size;
    final double topLeftRadiusX = _borderRadius.topLeft.x;
    final double topLeftRadiusY = _borderRadius.topLeft.y;
    final double topRightRadiusX = _borderRadius.topRight.x;
    final double topRightRadiusY = _borderRadius.topRight.y;
    final double bottomLeftRadiusX = _borderRadius.bottomLeft.x;
    final double bottomLeftRadiusY = _borderRadius.bottomLeft.y;
    final double bottomRightRadiusX = _borderRadius.bottomRight.x;
    final double bottomRightRadiusY = _borderRadius.bottomRight.y;

    final RRect roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.elliptical(topLeftRadiusX, topLeftRadiusY),
      topRight: Radius.elliptical(topRightRadiusX, topRightRadiusY),
      bottomLeft: Radius.elliptical(bottomLeftRadiusX, bottomLeftRadiusY),
      bottomRight: Radius.elliptical(bottomRightRadiusX, bottomRightRadiusY),
    );
    context.canvas.drawRRect(roundedRect, paint);
  }

  set width(double value) {
    if (_width != value) {
      _width = value;
      markNeedsLayout();
    }
  }

  set height(double value) {
    if (_height != value) {
      _height = value;
      markNeedsLayout();
    }
  }

  set color(Color value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  set borderRadius(BorderRadius value) {
    if (_borderRadius != value) {
      _borderRadius = value;
      markNeedsPaint();
    }
  }
}
