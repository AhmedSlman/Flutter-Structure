import 'dart:io';
import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

void run(HookContext context) {
  final pubspecFile = File('pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    context.logger.err('pubspec.yaml not found in project root.');
    context.vars['project_name'] = 'pride';
    return;
  }

  final content = pubspecFile.readAsStringSync();
  final yamlMap = loadYaml(content);

  final projectName = yamlMap['name'];
  context.vars['project_name'] = projectName ?? 'pride';

  context.logger.info('Project name detected: $projectName');
  //context.logger.info("Feature '$featureName' successfully added to router!");
}
