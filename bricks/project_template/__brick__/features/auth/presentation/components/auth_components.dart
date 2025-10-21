import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class AuthHeaderSection extends StatelessWidget {
  const AuthHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return AuthHeaderWidget(title: runtimeType.toString());
  }
}

class AuthBodySection extends StatelessWidget {
  const AuthBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return FutureBuilder(
      future: cubit.loadItems(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        return AuthBodyWidget(items: items);
      },
    );
  }
}
