import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/services/app_navigation_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/services/push_notification_service.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/main_view_body_bloc_consumer.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, this.initialViewIndex = 0});

  static const routeName = 'home_view';
  static const homeViewIndex = 0;
  static const productsViewIndex = 1;
  static const cartViewIndex = 2;
  static const ordersViewIndex = 3;
  final int initialViewIndex;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late int currentViewIndex;

  @override
  void initState() {
    super.initState();
    currentViewIndex = widget.initialViewIndex;
    AppNavigationService.setMainViewTab(currentViewIndex);
    AppNavigationService.mainViewTabNotifier.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<PushNotificationService>().registerCurrentUserDevice();
    });
  }

  @override
  void dispose() {
    AppNavigationService.mainViewTabNotifier.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    final targetIndex = AppNavigationService.mainViewTabNotifier.value;
    if (targetIndex == currentViewIndex) return;
    setState(() {
      currentViewIndex = targetIndex;
    });
  }

  void _setCurrentViewIndex(int index) {
    if (index == currentViewIndex) return;
    setState(() {
      currentViewIndex = index;
    });
    AppNavigationService.setMainViewTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          initialIndex: currentViewIndex,
          onItemTapped: _setCurrentViewIndex,
        ),
        body: SafeArea(
          child: MainViewBodyBlocConsumer(
            currentViewIndex: currentViewIndex,
            onCartPressed: () => _setCurrentViewIndex(MainView.cartViewIndex),
          ),
        ),
      ),
    );
  }
}
