import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const routeName = 'signup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "حساب جديد"),
      body: SignUpViewBody(),
    );
  }
}
