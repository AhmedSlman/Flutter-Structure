import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/extentions.dart';
import '../../../../../../shared/widgets/customtext.dart';
import '../../../../cubit/splash_cubit.dart';
import '../../../../cubit/splash_states.dart';

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = SplashCubit.get(context);
        return Expanded(
          child: PageView.builder(
            itemCount: cubit.onboardingModel.length,
            controller: cubit.controller,
            onPageChanged: (index) {
              cubit.updateSliderIndex(index);
            },
            itemBuilder: (context, index) {
              final item = cubit.onboardingModel[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  64.ph,
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(item.stackUrl),
                      FadeInLeft(child: Image.asset(item.imageUrl)),
                    ],
                  ),
                  const Spacer(),
                  CustomText(
                    item.title.tr(),
                    align: TextAlign.center,
                    fontSize: 20,
                    weight: FontWeight.w400,
                  ),
                  16.ph,
                  CustomText(
                    item.subTitle.tr(),
                    fontSize: 12,
                    weight: FontWeight.w400,
                  ),
                  64.ph,
                ],
              );
            },
          ),
        );
      },
    );
  }
}
