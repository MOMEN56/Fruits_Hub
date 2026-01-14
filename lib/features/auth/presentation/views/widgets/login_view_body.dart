import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/widgets/custom_button.dart';
import 'package:fruit_hub/core/utils/widgets/custom_text_field.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/features/auth/presentation/views/sign_up_view.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/is_have_account_widget.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/social_login_button.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            CustomTextFormField(
              hintText: 'البريد الإلكتروني',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              hintText: 'كلمة المرور',
              textInputType: TextInputType.visiblePassword,
              suffixIcon: const Icon(
                Icons.remove_red_eye,
                color: Color(0xFFC9CECF),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyles.semiBold13.copyWith(
                    color: AppColors.lightPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 33),
            CustomButton(onPressed: () {}, text: 'تسجيل دخول'),
            const SizedBox(height: 33),
            IsHaveAnAccountWidget(
              text1: 'لا تمتلك حساب؟',
              text2: 'قم بإنشاء حساب',
              onTap: () {
                Navigator.pushNamed(context, SignUpView.routeName);
              },
            ),
            const SizedBox(height: 33),
            const OrDivider(),
            const SizedBox(height: 16),
            SocialLoginButton(
              onPressed: () {},
              image: Assets.assetsImagesGoogleIcon,
              title: 'تسجيل بواسطة جوجل',
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              onPressed: () {},
              image: Assets.assetsImagesAppleIcon,
              title: 'تسجيل بواسطة أبل',
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              onPressed: () {},
              image: Assets.assetsImagesFacebookIcon,
              title: 'تسجيل بواسطة فيسبوك',
            ),
          ],
        ),
      ),
    );
  }
}
