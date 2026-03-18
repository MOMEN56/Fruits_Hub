import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/manger/cubit/add_order_cubit_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/add_order_cubit_bloc_builder.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/checkout_view_body.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CheckoutArgs {
  const CheckoutArgs({required this.cartEntity, required this.cartCubit});

  final CartEntity cartEntity;
  final CartCubit cartCubit;
}

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.cartEntity});

  static const routeName = 'checkout';
  final CartEntity cartEntity;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = getIt<CurrentUserService>().getCurrentUserId() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddOrderCubit(getIt<OrderRepo>())),
        BlocProvider(
          create:
              (_) => CheckoutCubit(
                cartEntity: widget.cartEntity,
                userId: _currentUserId,
              ),
        ),
      ],
      child: Scaffold(
        appBar: buildAppBar(
          context,
          title: S.of(context).shipping,
          showNotification: false,
        ),
        body: const AddOrderCubitBlocBuilder(child: CheckoutViewBody()),
      ),
    );
  }
}
