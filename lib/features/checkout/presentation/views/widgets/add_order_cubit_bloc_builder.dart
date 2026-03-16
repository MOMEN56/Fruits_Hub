import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/widgets/custom_progress_hud.dart';
import 'package:fruit_hub/features/checkout/presentation/manger/cubit/add_order_cubit_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/order_success_view.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
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
              builder:
                  (_) => PaymentView(
                    price:
                        state.order
                            .calculateTotalPriceAfterDiscountAndShipping(),
                    onPaymentSuccess: () {
                      if (!listenerContext.mounted) return;
                      Navigator.of(listenerContext).pop();
                      addOrderCubit.addOrder(order: state.order);
                    },
                    onPaymentError: () {
                      if (!listenerContext.mounted) return;
                      Navigator.of(listenerContext).pop();
                      buildSnackBar(
                        listenerContext,
                        '\u062D\u062F\u062B \u062E\u0637\u0623 \u0641\u064A \u0639\u0645\u0644\u064A\u0629 \u0627\u0644\u062F\u0641\u0639',
                      );
                    },
                  ),
            ),
          );
          return;
        }

        if (state is AddOrderFailure) {
          buildSnackBar(context, state.errorMessage);
          return;
        }

        if (state is AddOrderSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          await context.read<CartCubit>().clearCart();
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => OrderSuccessView(orderId: state.orderId),
            ),
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
