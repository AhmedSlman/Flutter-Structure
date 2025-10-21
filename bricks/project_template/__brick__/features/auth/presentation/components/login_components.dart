import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Router/router_names.dart';
import '../../../core/utils/navigate.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_states.dart';
import '../widgets/login_widgets.dart';

class LoginBodySection extends StatefulWidget {
  const LoginBodySection({super.key});

  @override
  State<LoginBodySection> createState() => _LoginBodySectionState();
}

class _LoginBodySectionState extends State<LoginBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigate.to(context, AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              EmailTextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                controller: _passwordController,
                labelText: 'Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              LoginButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              RegisterLinkButton(
                onPressed: () => Navigate.to(context, AppRoutes.register),
              ),
            ],
          ),
        );
      },
    );
  }
}
