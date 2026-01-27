import 'package:flutter/material.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/utils/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruit_hub/features/auth/presentation/cubits/singup_cubit/cubit/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/features/auth/presentation/views/widgets/signup_view_body_bloc_consumer.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  static const routeName = 'signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'حساب جديد'),
      body: BlocProvider(
        create: (context) => SignupCubit(getIt<AuthRepo>()),
        child: SignupViewbodyBlocConsumer(),
      ),
    );
  }
}
