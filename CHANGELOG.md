# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2024-10-13

### 🚀 Major Changes

- **Core Hybrid Architecture** - Best of both worlds
- **Migrated from Navigator to GoRouter** for better routing
- **Added Failure Pattern** - Clean Architecture error handling
- **Added ApiConsumer Pattern** - Professional network layer
- **Enhanced Caching** - Multi-strategy caching system
- **Improved DI** - Organized dependency injection

### ✨ Added

- `app_router.dart` - GoRouter configuration with all routes
- `MIGRATION_GUIDE.md` - Complete migration guide from Navigator to GoRouter
- `GOROUTER_USAGE.md` - Comprehensive GoRouter usage documentation
- Automatic route generation in feature hooks
- Custom page transitions support (Fade, Slide, etc.)
- Deep linking support out of the box
- Error page configuration

### 🔄 Changed

- `navigation_helper.dart` - Updated to use GoRouter extensions
- `main.dart` - Changed from `MaterialApp` to `MaterialApp.router`
- `Routes` class marked as deprecated, use `AppRoutes` instead
- Feature hooks now add routes to `app_router.dart` instead of `Router.dart`
- Removed `GlobalKey<NavigatorState>` from Locator (no longer needed)

### 📝 Updated

- README.md with GoRouter information
- All navigation examples to use GoRouter syntax
- Feature generation to work with GoRouter

### 🐛 Fixed

- Import errors in `webview_payment.dart`
- Missing `kDebugMode` import in `main.dart`
- Incorrect package imports in various files
- `.tr()` usage replaced with `LocalizationHelper`

### 📦 Dependencies

- Added: `go_router: ^14.0.0`

### 🗑️ Deprecated

- `Routes` class (use `AppRoutes` from `app_router.dart`)
- `RouteGenerator` class (no longer needed with GoRouter)
- Old navigation methods (see MIGRATION_GUIDE.md)

## [1.0.0] - Previous Version

### Initial Release

- Mason templates for Flutter projects
- Clean Architecture structure
- Navigator-based routing
- BLoC state management
- Localization support
- Theme system
- Auth templates
