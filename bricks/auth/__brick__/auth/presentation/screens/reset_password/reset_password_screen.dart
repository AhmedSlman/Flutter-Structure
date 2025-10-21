import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/Router/Router.dart';
import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/back_widget.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/customtext.dart';
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.code,
    required this.email,
  });
  final String code;
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    16.ph,
                    AppBar(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leadingWidth: 80,
                      // toolbarHeight: 80,
                      leading: BackWidget(size: 20),
                      title: CustomText(
                        'تغير كلمة المرور',
                        fontSize: 18,
                        color: context.primaryColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Center(
                      child: CustomText(
                        'قم بإدخال كلمة المرور الجديدة',
                        fontSize: 14,
                        color: context.secondaryColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    64.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormFieldWidget(
                        backgroundColor: context.primaryColor.withOpacity(.04),
                        // padding: const EdgeInsets.symmetric(horizontal: 18),
                        type: TextInputType.visiblePassword,
                        controller: passwordController,
                        prefixIcon: "",
                        hintText: 'كلمة المرور الجديدة',
                        password: true,
                        validator: Utils.valid.passwordValidation,
                        // controller: password,
                        borderRadius: 33,
                      ),
                    ),
                    20.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormFieldWidget(
                        backgroundColor: context.primaryColor.withOpacity(.04),
                        // padding: const EdgeInsets.symmetric(horizontal: 18),
                        type: TextInputType.visiblePassword,
                        prefixIcon: "",
                        hintText: 'إعادة كلمة المرور الجديدة',
                        password: true,
                        validator:
                            (v) => Utils.valid.confirmPasswordValidation(
                              v,
                              passwordController.text,
                            ),
                        // controller: password,
                        borderRadius: 33,
                        controller: confirmPasswordController,
                      ),
                    ),
                    32.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ButtonWidget(
                        title: "تغير ",
                        onTap: () async {
                          // log(widget.code);
                          // log(widget.mobile);
                          if (formKey.currentState!.validate()) {
                            final res = await cubit.resetPassword(
                              pass: passwordController.text.trim(),
                              email: widget.email,
                              code: widget.code,
                            );
                            if (res == true && context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.loginScreen,
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
