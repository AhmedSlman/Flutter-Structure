import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/extensions/all_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/alerts.dart';

class SnackDesgin extends StatelessWidget {
  const SnackDesgin({
    super.key,
    required this.text,
    this.state = SnackState.success,
  });

  final String text;
  final SnackState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          state == SnackState.success
              ? Lottie.asset(
                  "assets/json/success.json",
                  width: 30,
                  height: 30,
                )
              : Lottie.asset(
                  "assets/json/error.json",
                  width: 30,
                  height: 30,
                ),
          10.width,
          Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ).setContainerToView(
        color: state == SnackState.success
            ? context.primaryColor
            : context.errorColor,
        margin: 20,
        radius: 8,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
