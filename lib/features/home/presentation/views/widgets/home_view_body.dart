import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/widgets/search_text_field.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/best_selling_grid_view.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/best_selling_header.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/custom_home_appbar.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/featured_list.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: kTopPaddding),
                CustomHomeAppbar(),
                SizedBox(height: 16),
                SearchTextField(),
                SizedBox(height: 12),
                FeaturedList(),
                SizedBox(height: 12),
                BestSellingHeader(),
                SizedBox(height: 8),
              ],
            ),
          ),
          BestSellingGridView(),
        ],
      ),
    );
  }
}
