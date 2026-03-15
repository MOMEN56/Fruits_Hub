import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/products_cubit/cubit/products_cubit.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/search_text_field.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/best_selling_header.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/custom_home_appbar.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/featured_list.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
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
                    SizedBox(height: kTopPaddding),
                    CustomHomeAppbar(),
                    SizedBox(height: 16),
                    SearchTextField(
                      controller: _searchController,
                      onChanged: context.read<ProductsCubit>().searchProducts,
                      selectedSortOption: productsCubit.selectedSortOption,
                      onSortSelected:
                          context.read<ProductsCubit>().updateSortOption,
                    ),
                    SizedBox(height: 12),
                    FeaturedList(),
                    SizedBox(height: 12),
                    BestSellingHeader(),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              ProductsGridViewBlocBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
