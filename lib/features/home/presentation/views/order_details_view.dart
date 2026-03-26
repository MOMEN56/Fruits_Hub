import 'package:flutter/material.dart';
import 'package:fruit_hub/features/checkout/domain/entities/user_order_entity.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_details_view_body.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.order});

  final UserOrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: OrderDetailsViewBody(order: order),
        ),
      ),
    );
  }
}
