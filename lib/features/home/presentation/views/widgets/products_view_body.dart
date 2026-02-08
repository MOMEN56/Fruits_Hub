import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/products_cubit/cubit/products_cubit.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/products_view_header.dart';
import '../../../../../constants.dart';
import '../../../../../core/widgets/search_text_field.dart';
import 'products_grid_view_bloc_builder.dart';

class ProductsViewBody extends StatefulWidget {
  const ProductsViewBody({super.key});

  @override
  State<ProductsViewBody> createState() => _ProductsViewBodyState();
}

class _ProductsViewBodyState extends State<ProductsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: kTopPaddding),
                buildAppBar(context, title: "المنتجات", showBackButton: false),
                const SizedBox(height: 16),
                const SearchTextField(),
                const SizedBox(height: 12),
                ProductsViewHeader(
                  productsLength: context.read<ProductsCubit>().productsLength,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const ProductsGridViewBlocBuilder(),
        ],
      ),
    );
  }
}
