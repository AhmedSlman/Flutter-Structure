# Splash Router

This directory contains the routing configuration for the splash feature.

## Files

- `splash_router.dart` - Contains all splash-related GoRoutes
- `splash_names.dart` - Contains splash-specific route paths

## Routes

- `/` - Splash screen
- `/onboarding` - Onboarding screen

## Usage

The router is automatically imported and used in the main `AppRouter` class.

## Adding New Routes

1. Add the route path to `SplashRoutes` in `splash_names.dart`
2. Add the `GoRoute` to the `routes` getter in `splash_router.dart`
3. Import any new screens needed
4. Update the global `AppRoutes` in `core/Router/router_names.dart` if needed for navigation
