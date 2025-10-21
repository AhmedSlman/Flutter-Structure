 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/theme/dynamic_theme/colors.dart';
import 'customtext.dart';

import 'package:../../core/helpers/alerts.dart';
import 'package../../core/utils/utils.dart';
// import 'package:shareet/shared/back_widget.dart';

class WebViewPayment extends StatefulWidget {
  final String url;

  const WebViewPayment({super.key, required this.url});

  @override
  State<WebViewPayment> createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: MyText(text: 'pay_now'.tr(), color: AppColors.primary),
        // leading: const BackWidget(),
      ),
      body: SafeArea(
          child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {
                      debugPrint('''
          Page resource error:
        code: ${error.errorCode}
        description: ${error.description}
        errorType: ${error.errorType}
        isForMainFrame: ${error.isForMainFrame}
              ''');
                    },
                    onNavigationRequest: (NavigationRequest request) {
                      // if (request.url.startsWith('https://www.youtube.com/')) {
                      //   print("fffffffffff");
                      //   return NavigationDecision.prevent;
                      // }

                      // debugPrint(
                      //     "navigation url is ${request.url}");
                      // Uri uri = Uri.parse(request.url);
                      // String? responseCode =
                      //     uri.queryParameters['ResponseCode'];
                      // debugPrint("param1Value $responseCode");
                      // if (responseCode == "000") {
                      //   Utils.showMsg("تم الدفع بنجاح".tr());
                      //   Navigator.pop(context);
                      // }
                      return NavigationDecision.navigate;
                    },
                    onUrlChange: (UrlChange change) async {
                      debugPrint('url change to ${change.url}');
                      if (change.url?.contains('message=APPROVED') == true) {
                        Alerts.snack(text: 'payment_success'.tr(), state: 1);
                        Utils.userModel.hasPlan = true;

                        await Utils.saveUserInHive(Utils.userModel.toJson());
                        Future.delayed(const Duration(seconds: 2))
                            .then((value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // const LayoutScreen(index: 1)
                                          ),
                                  (route) => false,
                                ));
                      }
                    },
                  ),
                )
                ..loadRequest(Uri.parse(widget.url)))),
    );
  }
}
