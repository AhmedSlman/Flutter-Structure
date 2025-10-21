import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth_cubit.dart';
import '../components/forget_password_components.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(locator<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Forget Password')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: ForgetPasswordBodySection(),
        ),
      ),
    );
  }
}
