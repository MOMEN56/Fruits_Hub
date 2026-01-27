import 'package:flutter/material.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'homeView';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: SafeArea(child: HomeViewBody()),
      backgroundColor: Colors.white,
    );
  }
}
