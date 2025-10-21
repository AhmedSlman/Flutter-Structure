import 'package:go_router/go_router.dart';
import 'splash_names.dart';
import '../presentation/onboarding_screen.dart';
import '../presentation/splash_screen.dart';
import '../presentation/views/splash_view.dart';

class SplashRouter {
  static List<GoRoute> get routes => [
    // Splash Screen
    GoRoute(
      path: SplashRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding Screen
    GoRoute(
      path: SplashRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Splash View
    GoRoute(
      path: '/splash-view',
      builder: (context, state) => const SplashView(),
    ),
  ];
}
