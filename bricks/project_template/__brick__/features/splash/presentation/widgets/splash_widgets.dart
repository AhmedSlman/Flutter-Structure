import 'package:flutter/material.dart';

class SplashHeaderWidget extends StatelessWidget {
  final String title;
  const SplashHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class SplashBodyWidget extends StatelessWidget {
  final bool isLoading;
  const SplashBodyWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flutter_dash, size: 100),
          const SizedBox(height: 20),
          if (isLoading) const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text('Loading...'),
        ],
      ),
    );
  }
}
