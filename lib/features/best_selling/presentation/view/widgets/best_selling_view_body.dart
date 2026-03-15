import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/products_cubit/cubit/products_cubit.dart';
import 'package:fruit_hub/core/utils/products_sort_option.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/products_sort_bottom_sheet.dart';
import 'package:fruit_hub/core/widgets/search_text_field.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/products_view_header.dart';

class BestSellingViewBody extends StatefulWidget {
  const BestSellingViewBody({super.key});

  @override
  State<BestSellingViewBody> createState() => _BestSellingViewBodyState();
}

class _BestSellingViewBodyState extends State<BestSellingViewBody> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<ProductsCubit>().getBestSellingProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.watch<ProductsCubit>();
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SearchTextField(
                      controller: _searchController,
                      onChanged: context.read<ProductsCubit>().searchProducts,
                      selectedSortOption: productsCubit.selectedSortOption,
                      onSortSelected:
                          context.read<ProductsCubit>().updateSortOption,
                    ),
                    const SizedBox(height: 12),
                    ProductsViewHeader(
                      productsLength: productsCubit.productsLength,
                      isSortActive:
                          productsCubit.selectedSortOption !=
                          ProductsSortOption.none,
                      onFilterTap: () {
                        showProductsSortBottomSheet(
                          context: context,
                          selectedOption: productsCubit.selectedSortOption,
                          onSelected:
                              context.read<ProductsCubit>().updateSortOption,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const ProductsGridViewBlocBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
