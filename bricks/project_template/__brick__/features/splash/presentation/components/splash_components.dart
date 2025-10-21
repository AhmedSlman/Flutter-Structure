import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/splash_cubit.dart';
import '../widgets/splash_widgets.dart';

class SplashHeaderSection extends StatelessWidget {
  const SplashHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = SplashCubit.get(context);
    return SplashHeaderWidget(title: 'Splash Screen');
  }
}

class SplashBodySection extends StatelessWidget {
  const SplashBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = SplashCubit.get(context);
    return SplashBodyWidget(isLoading: false);
  }
}
