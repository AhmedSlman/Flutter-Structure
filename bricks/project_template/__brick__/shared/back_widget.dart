import 'package:flutter/material.dart';
import '../core/extensions/all_extensions.dart';


class BackWidget extends StatelessWidget {
  BackWidget({super.key, this.onBack, this.color, this.icon, this.size});
  final VoidCallback? onBack;
  final Color? color;
  final IconData? icon;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (onBack != null) {
            onBack?.call();
          } else {
            Navigator.pop(context);
          }
        },
        icon: Icon(
          icon ?? Icons.arrow_back_ios,
          color: color ?? context.colorScheme.primary,
          size: size,
        ));
  }
}
