import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      text: 'أضف إلى السلة',
      onPressed: () async {
        await context.read<CartCubit>().addProduct(
          widget.productEntity,
          quantity: selectedQuantity,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تمت إضافة $selectedQuantity من ${widget.productEntity.name} إلى السلة',
            ),
          ),
        );
      },
    );
  }
}
