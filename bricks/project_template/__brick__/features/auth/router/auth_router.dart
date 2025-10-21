import 'package:go_router/go_router.dart';
import 'auth_names.dart';
import '../presentation/views/login_view.dart';
import '../presentation/views/register_view.dart';
import '../presentation/views/forget_password_view.dart';
import '../presentation/views/otp_view.dart';
import '../presentation/views/reset_password_view.dart';
import '../presentation/views/auth_view.dart';

class AuthRouter {
  static List<GoRoute> get routes => [
    // Login View
    GoRoute(
      path: AuthRoutes.login,
      builder: (context, state) => const LoginView(),
    ),

    // Register View
    GoRoute(
      path: AuthRoutes.register,
      builder: (context, state) => const RegisterView(),
    ),

    // Forget Password View
    GoRoute(
      path: AuthRoutes.forgetPassword,
      builder: (context, state) => const ForgetPasswordView(),
    ),

    // OTP View
    GoRoute(path: AuthRoutes.otp, builder: (context, state) => const OtpView()),

    // Reset Password View
    GoRoute(
      path: AuthRoutes.resetPassword,
      builder: (context, state) => const ResetPasswordView(),
    ),

    // Auth View
    GoRoute(path: '/auth-view', builder: (context, state) => const AuthView()),
  ];
}
