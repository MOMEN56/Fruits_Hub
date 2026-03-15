import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/get_user.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entites/shipping_address_entity.dart';
import 'package:fruit_hub/features/checkout/presentation/manger/cubit/add_order_cubit_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/add_order_cubit_bloc_builder.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/checkout_view_body.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:provider/provider.dart';

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
  late OrderInputEntity orderEntity;

  @override
  void initState() {
    super.initState();
    orderEntity = OrderInputEntity(
      uID: getUser().uId,
      widget.cartEntity,
      shippingAddressEntity: ShippingAddressEntity(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddOrderCubit(getIt<OrderRepo>()),
      child: Scaffold(
        appBar: buildAppBar(title: 'الشحن', showNotification: false, context),
        body: Provider.value(
          value: orderEntity,
          child: const AddOrderCubitBlocBuilder(child: CheckoutViewBody()),
        ),
      ),
    );
  }
}
