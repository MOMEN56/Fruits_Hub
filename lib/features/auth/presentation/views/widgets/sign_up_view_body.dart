import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/core/widgets/custom_password_field.dart';
import 'package:fruit_hub/core/widgets/custom_text_field.dart';
import 'package:fruit_hub/features/auth/presentation/cubits/singup_cubit/cubit/signup_cubit.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/is_have_account_widget.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/terms_and_conditions.dart';
import 'package:fruit_hub/generated/l10n.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, userName, password;
  late bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Form(
              key: formkey,
              autovalidateMode: autoValidateMode,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    onSaved: (value) {
                      userName = value!;
                    },
                    hintText: l10n.fullNameHint,
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    onSaved: (value) {
                      email = value!;
                    },
                    hintText: l10n.emailHint,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomPasswordField(
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TermsAndConditionsWidget(
                    onChecked: (value) {
                      isTermsAccepted = value;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        if (isTermsAccepted) {
                          context
                              .read<SignupCubit>()
                              .createUserWithEmailAndPassword(
                                email,
                                password,
                                userName,
                              );
                        } else {
                          buildSnackBar(context, l10n.mustAcceptTerms);
                        }
                      } else {
                        setState(() {
                          autoValidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    text: l10n.createAccount,
                  ),
                  const SizedBox(height: 26),
                  IsHaveAnAccountWidget(
                    text1: l10n.alreadyHaveAccount,
                    text2: l10n.signIn,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
