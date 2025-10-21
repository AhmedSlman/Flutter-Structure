/// Auth feature route paths
class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
}

/// Auth feature arguments classes
class OtpArguments {
  final String sendTo;
  final bool? init;
  final dynamic Function(String) onSubmit;
  final void Function() onReSend;

  OtpArguments({
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });
}

class NewPasswordArgs {
  final String code;
  final String email;
  const NewPasswordArgs({required this.code, required this.email});
}
