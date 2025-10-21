import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/extensions/all_extensions.dart';
import '../../../../core/resources/gen/assets.gen.dart';
import '../../../../core/utils/extentions.dart';
import '../../cubit/layout_cubit.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar(
      {super.key, required this.onTap, required this.currentIndex});
  final Function(int)? onTap;
  final int currentIndex;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: context.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navBarItem(Assets.icons.workspace, LocaleKeys.navBar_workSpace.tr(),
              0, Assets.icons.workspaceOn),
          navBarItem(Assets.icons.req, LocaleKeys.navBar_approval.tr(), 1,
              Assets.icons.reqOn),
          navBarItem(
              Assets.icons.notification,
              LocaleKeys.navBar_notifications.tr(),
              2,
              Assets.icons.notificationOn),
          navBarItem(Assets.icons.settings, LocaleKeys.navBar_settings.tr(), 3,
              Assets.icons.settingsOn),
        ],
      ),
    );
    // ),
  }

  Widget navBarItem(String path, String title, int index, String pathActive,
      {VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<LayoutCubit>().changeTab(index);
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              context.read<LayoutCubit>().tabController.index == index
                  ? Column(
                      children: [
                        SvgPicture.asset(
                          pathActive,
                          width: 27,
                          height: 27,
                        ),
                        6.ph,
                        Text(
                          title,
                          style: context.bodySmall?.copyWith(
                            color: context.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                        // TextWidget(
                        //   title,
                        //   color: context.primaryColor,
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w600,
                        // ),
                      ],
                    )
                  : Column(
                      children: [
                        SvgPicture.asset(
                          path,
                          width: 25,
                          height: 25,
                          color: context.tertiaryColor,
                        ),
                        6.ph,
                        Text(
                          title,
                          style: context.bodySmall?.copyWith(
                            color: context.tertiaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                        // TextWidget(
                        //
                        //
                        //
                        // ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
