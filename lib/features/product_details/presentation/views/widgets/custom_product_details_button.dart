import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/product_details_veiw_body.dart';

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
    return CustomButton(
      width: width,
      height: height,
      text:
          '\u0623\u0636\u0641 \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629',
      onPressed: () async {
        await context.read<CartCubit>().addProduct(
          widget.productEntity,
          quantity: selectedQuantity,
        );
        if (!context.mounted) return;
        buildSnackBar(
          context,
          '\u062A\u0645\u062A \u0625\u0636\u0627\u0641\u0629 $selectedQuantity \u0645\u0646 ${widget.productEntity.name} \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629',
          type: AppSnackBarType.success,
          title:
              '\u062A\u0645\u062A \u0627\u0644\u0625\u0636\u0627\u0641\u0629',
        );
      },
    );
  }
}
