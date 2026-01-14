import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/utils/widgets/custom_button.dart';
import 'package:fruit_hub/core/utils/widgets/custom_text_field.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/is_have_account_widget.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/terms_and_conditions.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            CustomTextFormField(
              hintText: 'الاسم كامل',
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: 16),
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
            TermsAndConditionsWidget(),
            const SizedBox(height: 30),
            CustomButton(onPressed: () {}, text: "إنشاء حساب"),
            const SizedBox(height: 26),
            IsHaveAnAccountWidget(
              text1: "تمتلك حساب بالفعل؟",
              text2: "تسجيل دخول",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
