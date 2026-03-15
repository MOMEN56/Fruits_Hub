import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/widgets/custom_progress_hud.dart';
import 'package:fruit_hub/features/checkout/presentation/manger/cubit/add_order_cubit_cubit.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class AddOrderCubitBlocBuilder extends StatelessWidget {
  const AddOrderCubitBlocBuilder({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOrderCubit, AddOrderState>(
      listener: (context, state) async {
        if (state is AddOrderNeedsOnlinePayment) {
          final listenerContext = context;
          final addOrderCubit = listenerContext.read<AddOrderCubit>();
          Navigator.of(listenerContext).push(
            MaterialPageRoute(
              builder: (_) => PaymentView(
                price: state.order.calculateTotalPriceAfterDiscountAndShipping(),
                onPaymentSuccess: () {
                  if (!listenerContext.mounted) return;
                  Navigator.of(listenerContext).pop();
                  addOrderCubit.addOrder(order: state.order);
                },
                onPaymentError: () {
                  if (!listenerContext.mounted) return;
                  Navigator.of(listenerContext).pop();
                  ScaffoldMessenger.of(listenerContext).showSnackBar(
                    const SnackBar(content: Text('حدث خطأ في عملية الدفع')),
                  );
                },
              ),
            ),
          );
          return;
        }

        if (state is AddOrderFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          return;
        }

        if (state is AddOrderSuccess) {
          await context.read<CartCubit>().clearCart();
          if (!context.mounted) return;
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainView.routeName,
            (route) => false,
            arguments: 3,
          );
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is AddOrderLoading,
          child: child,
        );
      },
    );
  }
}
