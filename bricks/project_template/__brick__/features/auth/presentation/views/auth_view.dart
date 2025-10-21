import 'package:flutter/material.dart';
import '../components/auth_components.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            // Compose components only. No logic and no design here.
            AuthHeaderSection(),
            AuthBodySection(),
          ],
        ),
      ),
    );
  }
}
