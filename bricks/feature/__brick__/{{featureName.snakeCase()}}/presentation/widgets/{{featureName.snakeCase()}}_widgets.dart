import 'package:flutter/material.dart';

class {{featureName.pascalCase()}}HeaderWidget extends StatelessWidget {
  final String title;
  const {{featureName.pascalCase()}}HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title),
    );
  }
}

class {{featureName.pascalCase()}}BodyWidget extends StatelessWidget {
  final List items;
  const {{featureName.pascalCase()}}BodyWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item #$index'),
        );
      },
    );
  }
}


