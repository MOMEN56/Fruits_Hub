import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/core/widgets/custom_password_field.dart';
import 'package:fruit_hub/core/widgets/custom_text_field.dart';
import 'package:fruit_hub/features/auth/presentation/cubits/signin_cubit/cubit/signin_cubit.dart';
import 'package:fruit_hub/features/auth/presentation/views/sign_up_view.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/is_have_account_widget.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/social_signin_view_button.dart';
import 'package:fruit_hub/generated/l10n.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  const SizedBox(height: 24),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l10n.forgotPassword,
                        style: TextStyles.semiBold13.copyWith(
                          color: AppColors.lightPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 33),
                  CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        context.read<SigninCubit>().signin(email, password);
                      } else {
                        autovalidateMode = AutovalidateMode.always;
                        setState(() {});
                      }
                    },
                    text: l10n.signIn,
                  ),
                  const SizedBox(height: 33),
                  IsHaveAnAccountWidget(
                    text1: l10n.noAccount,
                    text2: l10n.createAccount,
                    onTap: () {
                      Navigator.pushNamed(context, SignUpView.routeName);
                    },
                  ),
                  const SizedBox(height: 33),
                  const OrDivider(),
                  const SizedBox(height: 16),
                  SocialSigninViewButton(
                    onPressed: () {
                      context.read<SigninCubit>().signinWithGoogle();
                    },
                    image: Assets.assetsImagesGoogleIcon,
                    title: l10n.signInWithGoogle,
                  ),
                  const SizedBox(height: 16),
                  SocialSigninViewButton(
                    onPressed: () {
                      context.read<SigninCubit>().signinWithFacebook();
                    },
                    image: Assets.assetsImagesFacebookIcon,
                    title: l10n.signInWithFacebook,
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
