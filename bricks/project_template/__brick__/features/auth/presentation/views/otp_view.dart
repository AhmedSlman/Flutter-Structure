import 'package:flutter/material.dart';
import '../components/otp_components.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: const OtpBodySection(),
    );
  }
}
