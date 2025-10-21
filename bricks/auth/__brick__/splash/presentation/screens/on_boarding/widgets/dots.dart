import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/extensions/all_extensions.dart';
import '../../../../cubit/splash_cubit.dart';
import '../../../../cubit/splash_states.dart';

class DotsWidget extends StatefulWidget {
  const DotsWidget({super.key, required this.index});

  final int index;

  @override
  State<DotsWidget> createState() => _DotsWidgetState();
}

class _DotsWidgetState extends State<DotsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = SplashCubit.get(context);
        // print(widget.index);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color:
                cubit.sliderIndex == widget.index
                    ? context.primaryColor
                    : Color(0xffE6E6E6),
          ),
          margin: const EdgeInsets.only(right: 5),
          height: cubit.sliderIndex == widget.index ? 18 : 14,
          curve: Curves.easeIn,
          width: cubit.sliderIndex == widget.index ? 18 : 14,
        );
      },
    );
  }
}
