import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

class MyLoading {
  static bool shown = false;

  static show({
    bool fullScreen = false,
  }) {
    if (shown == false) {
      SmartDialog.show(
          clickMaskDismiss: false,
          animationType: SmartAnimationType.scale,
          animationTime: const Duration(milliseconds: 100),
          keepSingle: true,
          builder: (context) => fullScreen
              ? loadingWidget()
              : Dialog(
                  child: SizedBox(
                      width: 200, height: 200, child: loadingWidget())));

      shown = true;
    }
  }

  static Center loadingWidget() => const Center(child: CircularProgressIndicator());

  static dismis() {
    if (shown) {
      SmartDialog.dismiss();
      shown = false;
    } else {}
  }
}

class MySuccess {
  static bool shown = false;

  static show({
    bool fullScreen = false,
  }) {
    if (shown == false) {
      SmartDialog.show(
          clickMaskDismiss: false,
          animationType: SmartAnimationType.scale,
          animationTime: const Duration(milliseconds: 100),
          keepSingle: true,
          builder: (context) => fullScreen
              ? SuccessWidget()
              : Dialog(
              child: SizedBox(
                  width: 200, height: 200, child: SuccessWidget())));

      shown = true;
    }
  }

  // static Center SuccessWidget() =>  Center(child: Lottie.asset("assets/json/success.json"));

  static dismis() {
    if (shown) {
      SmartDialog.dismiss();
      shown = false;
    } else {}
  }

}

class SuccessWidget extends StatefulWidget {
  const SuccessWidget({super.key});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      MySuccess.dismis();
    });
  }
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/json/success.json"));
  }
}
