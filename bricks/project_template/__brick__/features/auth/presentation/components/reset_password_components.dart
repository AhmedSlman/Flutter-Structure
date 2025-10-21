import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Router/router_names.dart';
import '../../../core/utils/navigate.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_states.dart';
import '../widgets/reset_password_widgets.dart';

class ResetPasswordBodySection extends StatelessWidget {
  const ResetPasswordBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthResetPasswordSuccess) {
          Navigate.to(context, AppRoutes.login);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ResetPasswordBodyWidget(
          email: 'test@test.com',
          onResetPressed: () => cubit.resetPassword('123456', 'newPassword123'),
          onBackToLoginPressed: () => Navigate.to(context, AppRoutes.login),
        );
      },
    );
  }
}
