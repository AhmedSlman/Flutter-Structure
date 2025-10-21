import 'package:flutter/material.dart';

class OtpBodyWidget extends StatelessWidget {
  final String sendTo;
  final Function(String) onVerifyPressed;
  final VoidCallback onResendPressed;

  const OtpBodyWidget({
    super.key,
    required this.sendTo,
    required this.onVerifyPressed,
    required this.onResendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('OTP sent to: $sendTo'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => onVerifyPressed('123456'),
            child: const Text('Verify OTP'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onResendPressed,
            child: const Text('Resend OTP'),
          ),
        ],
      ),
    );
  }
}
