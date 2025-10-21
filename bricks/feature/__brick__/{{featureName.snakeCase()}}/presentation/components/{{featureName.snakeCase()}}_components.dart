import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/{{featureName.snakeCase()}}_cubit.dart';
import '../widgets/{{featureName.snakeCase()}}_widgets.dart';

class {{featureName.pascalCase()}}HeaderSection extends StatelessWidget {
  const {{featureName.pascalCase()}}HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = {{featureName.pascalCase()}}Cubit.get(context);
    return {{featureName.pascalCase()}}HeaderWidget(
      title: runtimeType.toString(),
    );
  }
}

class {{featureName.pascalCase()}}BodySection extends StatelessWidget {
  const {{featureName.pascalCase()}}BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = {{featureName.pascalCase()}}Cubit.get(context);
    return FutureBuilder(
      future: cubit.loadItems(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        return {{featureName.pascalCase()}}BodyWidget(
          items: items,
        );
      },
    );
  }
}


