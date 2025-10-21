import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/router/auth_router.dart';
import '../../features/home/router/home_router.dart';
import '../../features/splash/router/splash_router.dart';
import 'router_names.dart';

/// GoRouter configuration
class AppRouter {
  static String initialRoute = AppRoutes.splash;

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: true,
    routes: [
      // Feature Routers
      ...SplashRouter.routes,
      ...AuthRouter.routes,
      ...HomeRouter.routes,
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'الصفحة غير موجودة',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.splash),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
