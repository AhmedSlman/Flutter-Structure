import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth_cubit.dart';
import '../components/register_components.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(locator<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: RegisterBodySection(),
        ),
      ),
    );
  }
}
