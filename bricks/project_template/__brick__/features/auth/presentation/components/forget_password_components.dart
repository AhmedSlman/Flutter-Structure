import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Router/router_names.dart';
import '../../../core/utils/navigate.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_states.dart';
import '../widgets/login_widgets.dart';

class ForgetPasswordBodySection extends StatefulWidget {
  const ForgetPasswordBodySection({super.key});

  @override
  State<ForgetPasswordBodySection> createState() =>
      _ForgetPasswordBodySectionState();
}

class _ForgetPasswordBodySectionState extends State<ForgetPasswordBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccess) {
          Navigate.to(context, AppRoutes.otp);
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
              const Text(
                'Enter your email address and we\'ll send you a reset code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              EmailTextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SendResetButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.forgotPassword(_emailController.text);
                  }
                },
              ),
              const SizedBox(height: 16),
              BackToLoginButton(
                onPressed: () => Navigate.to(context, AppRoutes.login),
              ),
            ],
          ),
        );
      },
    );
  }
}
