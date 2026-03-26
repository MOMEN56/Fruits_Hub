import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/main_view_body.dart';
import 'package:fruit_hub/generated/l10n.dart';

class MainViewBodyBlocConsumer extends StatelessWidget {
  const MainViewBodyBlocConsumer({
    super.key,
    required this.currentViewIndex,
    required this.onCartPressed,
  });

  final int currentViewIndex;
  final VoidCallback onCartPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) return;

        if (state is CartItemAdded) {
          buildSnackBar(
            context,
            l10n.productAddedToCart,
            type: AppSnackBarType.success,
            title: l10n.addSuccessTitle,
            actionLabel: l10n.cart,
            onAction: onCartPressed,
            duration: const Duration(seconds: 3),
          );
        } else if (state is CartItemRemoved) {
          buildSnackBar(
            context,
            l10n.productRemovedFromCart,
            type: AppSnackBarType.success,
            title: l10n.updateTitle,
            duration: const Duration(seconds: 1),
          );
        }
      },
      child: MainViewBody(currentViewIndex: currentViewIndex),
    );
  }
}
