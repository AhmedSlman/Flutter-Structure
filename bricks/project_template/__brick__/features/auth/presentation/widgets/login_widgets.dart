import 'package:flutter/material.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EmailTextFormField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
    );
  }
}

class PasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;

  const PasswordTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
      ),
    );
  }
}

class NameTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const NameTextFormField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Login'),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const RegisterButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Register'),
      ),
    );
  }
}

class SendResetButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SendResetButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Send Reset Code'),
      ),
    );
  }
}

class RegisterLinkButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RegisterLinkButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('Don\'t have an account? Register'),
    );
  }
}

class LoginLinkButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginLinkButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('Already have an account? Login'),
    );
  }
}

class BackToLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackToLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: const Text('Back to Login'));
  }
}
