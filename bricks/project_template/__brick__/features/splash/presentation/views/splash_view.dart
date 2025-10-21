import 'package:flutter/material.dart';
import '../components/splash_components.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            // Compose components only. No logic and no design here.
            SplashHeaderSection(),
            SplashBodySection(),
          ],
        ),
      ),
    );
  }
}
