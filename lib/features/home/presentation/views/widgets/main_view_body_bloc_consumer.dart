import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/main_view_body.dart';

class MainViewBodyBlocConsumer extends StatelessWidget {
  const MainViewBodyBlocConsumer({super.key, required this.currentViewIndex});

  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartItemAdded) {
          buildSnackBar(
            context,
            '\u062A\u0645\u062A \u0625\u0636\u0627\u0641\u0629 \u0627\u0644\u0645\u0646\u062A\u062C \u0644\u0644\u0633\u0644\u0629',
            type: AppSnackBarType.success,
            title:
                '\u062A\u0645\u062A \u0627\u0644\u0625\u0636\u0627\u0641\u0629',
            duration: const Duration(seconds: 1),
          );
        } else if (state is CartItemRemoved) {
          buildSnackBar(
            context,
            '\u062A\u0645 \u062D\u0630\u0641 \u0627\u0644\u0645\u0646\u062A\u062C \u0645\u0646 \u0627\u0644\u0633\u0644\u0629',
            type: AppSnackBarType.success,
            title: '\u062A\u0645 \u0627\u0644\u062A\u062D\u062F\u064A\u062B',
            duration: const Duration(seconds: 1),
          );
        }
      },
      child: MainViewBody(currentViewIndex: currentViewIndex),
    );
  }
}
