import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final featureName = context.vars['featureName'] as String;
  final insertRoute = context.vars['insertRoute'] as bool? ??
      false; // Check if insertRoute is true

  if (!insertRoute) {
    context.logger.info("Skipping router update as insertRoute is false.");
    return;
  }

  // final routerPath =
  //   '../lib/core/router.dart'; // Adjust based on your project structure
  final masonPath = Directory.current.path;

  // Move up one level to get the main project path
  final projectPath = Directory(masonPath).parent.path;

  // Define the correct path for router.dart in the main project
  final routerPath = '$projectPath/core/Router/Router.dart';
  if (!File(routerPath).existsSync()) {
    context.logger.warn(routerPath);

    context.logger.warn("Router.dart not found!");
    return;
  }

  updateRouterFile(routerPath, featureName);
  context.logger.info("Feature '$featureName' successfully added to router!");
}

void updateRouterFile(String routerPath, String featureName) {
  final file = File(routerPath);
  String content = file.readAsStringSync();

  final importStatement =
      "import '../../features/${snakeCase(featureName)}/presentation/screens/${snakeCase(featureName)}_screen.dart';";
  final routeConst =
      "  static const String ${camelCase(featureName)}Screen = \"${camelCase(featureName)}Screen\";";
  final routeCase = """
  case Routes.${camelCase(featureName)}Screen:
    return CupertinoPageRoute(
        settings: routeSettings,
        builder: (_) {
          return const ${pascalCase(featureName)}Screen();
        });""";

  // Add import statement if missing
  if (!content.contains(importStatement)) {
    content = "$importStatement\n$content";
  }

  // Insert routeConst inside class Routes
  final routesClassIndex = content.indexOf("class Routes");
  if (routesClassIndex != -1 && !content.contains(routeConst)) {
    final classEndIndex = findClassEndIndex(content, routesClassIndex);
    if (classEndIndex != -1) {
      content = content.substring(0, classEndIndex) +
          '\n$routeConst\n' +
          content.substring(classEndIndex);
    }
  }

  // Insert routeCase inside switch statement before default
  final switchIndex = content.indexOf("switch (routeSettings.name)");
  if (switchIndex != -1 && !content.contains(routeCase)) {
    final defaultIndex = content.indexOf("default:", switchIndex);
    if (defaultIndex != -1) {
      content = content.substring(0, defaultIndex) +
          '$routeCase\n' +
          content.substring(defaultIndex);
    }
  }

  file.writeAsStringSync(content);
}

int findClassEndIndex(String content, int classStartIndex) {
  int openBraces = 0;
  for (int i = classStartIndex; i < content.length; i++) {
    if (content[i] == '{') {
      openBraces++;
    } else if (content[i] == '}') {
      openBraces--;
      if (openBraces == 0) {
        return i;
      }
    }
  }
  return -1;
}

// Utility Functions for Naming Conventions
String snakeCase(String input) {
  return input
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'),
          (m) => '${m[1]}_${m[2]}') // Convert camelCase to snake_case
      .replaceAll(
          RegExp(r'\s+|-+'), '_') // Replace spaces and hyphens with underscores
      .toLowerCase();
}

String pascalCase(String input) {
  return input
      .replaceAllMapped(RegExp(r'(^|_|-)([a-z])'),
          (m) => m[2]!.toUpperCase()) // Capitalize letters after _ and -
      .replaceAll(RegExp(r'_|-'), ''); // Remove underscores and hyphens
}

String camelCase(String input) {
  String pascal = pascalCase(input);
  return pascal[0].toLowerCase() + pascal.substring(1);
}
