import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/product_details_veiw_body.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CustomProductDetailsButton extends StatelessWidget {
  const CustomProductDetailsButton({
    super.key,
    required this.widget,
    required this.selectedQuantity,
    this.width,
    this.height,
  });

  final ProductDetailsViewBody widget;
  final int selectedQuantity;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return CustomButton(
      width: width,
      height: height,
      text: l10n.addToCart,
      onPressed: () async {
        await context.read<CartCubit>().addProduct(
          widget.productEntity,
          quantity: selectedQuantity,
        );
        if (!context.mounted) return;
        buildSnackBar(
          context,
          l10n.addedQuantityToCart(selectedQuantity, widget.productEntity.name),
          type: AppSnackBarType.success,
          title: l10n.addSuccessTitle,
        );
      },
    );
  }
}
