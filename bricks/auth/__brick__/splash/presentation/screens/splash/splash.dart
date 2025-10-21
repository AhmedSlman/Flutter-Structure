import 'package:animated_widgets_flutter/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/Router/Router.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';

///// put it in routes
///  import '../../modules/splash/presentation/splash.dart';
/// static const String splashScreen = "/splashScreen";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff4F0000),
        body: BlocConsumer<SplashCubit, SplashStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Center(
              child: OpacityAnimatedWidget.tween(
                opacityEnabled: 1,
                opacityDisabled: 0,
                duration: const Duration(
                  milliseconds: 2000,
                ), // Reduced animation time
                enabled: true,
                animationFinished: (finished) async {
                  if (mounted) {
                    // Prevent memory leaks
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.OnboardingScreen,
                    ); // Use replacement to clear stack
                  }
                },
                child: SvgPicture.asset(
                  "app_logo".svg('icons'),
                  width: 200, // Constrain size
                  height: 250,
                  cacheColorFilter: true, // Enable caching
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
