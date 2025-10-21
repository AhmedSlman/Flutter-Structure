import 'package:flutter/material.dart';
import '../components/{{featureName.snakeCase()}}_components.dart';

class {{featureName.pascalCase()}}View extends StatelessWidget {
  const {{featureName.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            // Compose components only. No logic and no design here.
            {{featureName.pascalCase()}}HeaderSection(),
            {{featureName.pascalCase()}}BodySection(),
          ],
        ),
      ),
    );
  }
}


