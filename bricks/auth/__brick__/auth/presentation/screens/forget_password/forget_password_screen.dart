import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
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
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leadingWidth: 80,
                // toolbarHeight: 80,
                leading: BackWidget(
                  size: 20,
                ),
                title: CustomText(
                  'هل نسيت كلمة المرور',
                  fontSize: 18,
                  color: context.primaryColor,
                  weight: FontWeight.w700,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        'قم بإدخال بياناتك لتسجيل الدخول',
                        fontSize: 14,
                        color: Colors.black,
                        weight: FontWeight.w300,
                      ),
                      40.ph,
                      SvgPicture.asset(
                        "forget_pass".svg("icons"),
                        width: 212,
                        height: 212,
                      ),
                      50.ph,
                      TextFormFieldWidget(
                        backgroundColor: context.primaryColor.withOpacity(.04),
                        // padding: const EdgeInsets.symmetric(horizontal: 18),
                        type: TextInputType.emailAddress,
                        prefixIcon: "",
                        hintText: 'البريد الالكتروني',
                        password: false,
                        validator: Utils.valid.emailValidation,
                        controller: email,
                        borderRadius: 33,
                      ),
                      30.ph,
                      ButtonWidget(
                        title: 'إرسال',
                        withBorder: true,
                        buttonColor: context.primaryColor,
                        textColor: Colors.white,
                        borderColor: context.primaryColor,
                        width: double.infinity,
                        // padding: const EdgeInsets.symmetric(horizontal: 15),
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            final response = await cubit.forgetPass(email.text);
                            if (response != null) {
                              Navigator.pushNamed(context, Routes.otpScreen,
                                  arguments: OtpArguments(
                                    sendTo: email.text,
                                    onSubmit: (code) async {
                                      final res = await cubit.sendCode(
                                          email: email.text, code: code);
                                      if (res == true) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.resetPasswordScreen,
                                          arguments: NewPasswordArgs(
                                            code: cubit.codeId,
                                            email: email.text,
                                          ),
                                        );
                                      }
                                    },
                                    onReSend: () async {
                                      await cubit.resendCode(email.text);
                                    },
                                    init: false,
                                  ));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
