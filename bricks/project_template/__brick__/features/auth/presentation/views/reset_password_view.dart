import 'package:flutter/material.dart';
import '../components/reset_password_components.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: const ResetPasswordBodySection(),
    );
  }
}
