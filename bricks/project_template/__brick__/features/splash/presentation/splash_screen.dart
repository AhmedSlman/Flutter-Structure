import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/splash_cubit.dart';
import '../logic/splash_states.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..checkAuthStatus(),
      child: BlocBuilder<SplashCubit, SplashStates>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flutter_dash, size: 100),
                  const SizedBox(height: 20),
                  if (state is SplashLoading) const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text('Loading...'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
