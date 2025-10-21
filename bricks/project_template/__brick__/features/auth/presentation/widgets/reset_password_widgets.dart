import 'package:flutter/material.dart';

class ResetPasswordBodyWidget extends StatelessWidget {
  final String email;
  final VoidCallback onResetPressed;
  final VoidCallback onBackToLoginPressed;

  const ResetPasswordBodyWidget({
    super.key,
    required this.email,
    required this.onResetPressed,
    required this.onBackToLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Reset password for: $email'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onResetPressed,
            child: const Text('Reset Password'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onBackToLoginPressed,
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}
