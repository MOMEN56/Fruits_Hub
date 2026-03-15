import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/fruit_item.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/product_details/presentation/views/product_details_view.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({super.key, required this.products});
  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveLayout.productsGridCount(
          constraints.crossAxisExtent,
        );
        final crossAxisSpacing = crossAxisCount > 2 ? 20.0 : 12.0;

        return SliverGrid.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 163 / 225,
            mainAxisSpacing: 12,
            crossAxisSpacing: crossAxisSpacing,
          ),
          itemBuilder: (context, index) {
            return FruitItem(
              productEntity: products[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<CartCubit>(),
                      child: ProductDetailsView(
                        productEntity: products[index],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
