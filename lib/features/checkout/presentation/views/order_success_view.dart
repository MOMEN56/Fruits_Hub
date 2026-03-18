import 'package:flutter/material.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/order_success_view_body.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(
        context,
        title: S.of(context).payment,
        showBackButton: false,
        showNotification: false,
      ),
      body: OrderSuccessViewBody(orderId: orderId),
    );
  }
}
