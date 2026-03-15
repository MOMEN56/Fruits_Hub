import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/services/push_notification_service.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/main_view_body_bloc_consumer.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, this.initialViewIndex = 0});

  static const routeName = 'home_view';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<PushNotificationService>().registerCurrentUserDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          initialIndex: widget.initialViewIndex,
          onItemTapped: (index) {
            currentViewIndex = index;
            setState(() {});
          },
        ),
        body: SafeArea(
          child: MainViewBodyBlocConsumer(currentViewIndex: currentViewIndex),
        ),
      ),
    );
  }
}
