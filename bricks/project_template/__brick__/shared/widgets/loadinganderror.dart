import 'package:flutter/material.dart';

import '../../core/utils/extentions.dart';
import '../../core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'button_widget.dart';
import 'customtext.dart';

class LoadingAndError extends StatelessWidget {
  const LoadingAndError({Key? key, required this.isError, required this.isLoading, this.function, required this.child})
      : super(key: key);
  final bool isError;
  final bool isLoading;
  final Widget child;
  final Function? function;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (
      context,
    ) {
      if (isError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                'data_error'.tr(),
                fontSize: 18,
                color: context.primaryColor,
              ),
              24.ph,
              if (Navigator.canPop(context) || function != null)
                ButtonWidget(
                    // radius: 20,
                    withBorder: true,
                    width: 150,
                    height: 50,
                    // borderColor: Color(0xffDAF1DE),
                    // buttonColor: Color(0xffDAF1DE),
                    onTap: () async {
                      function != null
                          ? await function!()
                          : Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                      // Navigator.pop(context);
                    },
                    child: CustomText(
                      function != null ? "retry".tr() : "go_back".tr(),
                      color: AppColors.onPrimary,
                      fontSize: 18,
                      weight: FontWeight.w500,
                    ))
            ],
          ),
        );
      } else if (isLoading) {
        return Material(
          color: context.backgroundColor,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return child;
      }
    });
  }
}
