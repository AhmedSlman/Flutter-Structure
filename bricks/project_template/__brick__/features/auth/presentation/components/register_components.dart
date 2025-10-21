import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Router/router_names.dart';
import '../../../core/utils/navigate.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_states.dart';
import '../widgets/login_widgets.dart';

class RegisterBodySection extends StatefulWidget {
  const RegisterBodySection({super.key});

  @override
  State<RegisterBodySection> createState() => _RegisterBodySectionState();
}

class _RegisterBodySectionState extends State<RegisterBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              NameTextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              RegisterButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.register(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              LoginLinkButton(
                onPressed: () => Navigate.to(context, AppRoutes.login),
              ),
            ],
          ),
        );
      },
    );
  }
}
