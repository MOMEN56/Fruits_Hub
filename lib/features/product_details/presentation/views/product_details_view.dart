import 'package:flutter/material.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/product_details_veiw_body.dart';

class ProductDetailsArgs {
  const ProductDetailsArgs({
    required this.productEntity,
    required this.cartCubit,
  });

  final ProductEntity productEntity;
  final CartCubit cartCubit;
}

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.productEntity});
  final ProductEntity productEntity;
  static const String routeName = 'product_details';
  @override
  Widget build(BuildContext context) {
    return ProductDetailsViewBody(productEntity: productEntity);
  }
}
