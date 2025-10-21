import 'package:go_router/go_router.dart';
import '{{featureName.snakeCase()}}_names.dart';
import '../presentation/views/{{featureName.snakeCase()}}_view.dart';

class {{featureName.pascalCase()}}Router {
  static List<GoRoute> get routes => [
    // {{featureName.pascalCase()}} Screen
    GoRoute(
      path: {{featureName.pascalCase()}}Routes.{{featureName.camelCase()}},
      builder: (context, state) => const {{featureName.pascalCase()}}View(),
    ),
  ];
}
