import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Router/router_names.dart';
import '../../../core/utils/navigate.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_states.dart';
import '../widgets/otp_widgets.dart';

class OtpBodySection extends StatelessWidget {
  const OtpBodySection({super.key});

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
        return OtpBodyWidget(
          sendTo: 'test@test.com',
          onVerifyPressed: (otp) => cubit.login('test@test.com', 'password'),
          onResendPressed: () => cubit.forgotPassword('test@test.com'),
        );
      },
    );
  }
}
