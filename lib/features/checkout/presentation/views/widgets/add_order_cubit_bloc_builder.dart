import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/widgets/custom_progress_hud.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/add_order_cubit/add_order_cubit.dart';
import 'package:fruit_hub/features/checkout/domain/entities/shipping_address_entity.dart';
import 'package:fruit_hub/features/checkout/presentation/views/order_success_view.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/generated/l10n.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class AddOrderCubitBlocBuilder extends StatelessWidget {
  const AddOrderCubitBlocBuilder({super.key, required this.child});
  final Widget child;

  UserData _userDataFromShipping(ShippingAddressEntity shipping) {
    final fullName = shipping.name?.trim() ?? '';
    final parts =
        fullName.split(' ').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final firstName = parts.isNotEmpty ? parts.first : 'NA';
    final lastName =
        parts.length > 1 ? parts.sublist(1).join(' ') : firstName;

    final email = shipping.email?.trim();
    final phoneRaw = shipping.phone?.trim();
    // Paymob expects a non-empty string; remove spaces and keep + and digits.
    final phone = phoneRaw == null
        ? null
        : phoneRaw.replaceAll(RegExp(r'[^0-9+]'), '');

    return UserData(
      name: firstName,
      lastName: lastName,
      email: (email != null && email.isNotEmpty) ? email : 'NA',
      phone: (phone != null && phone.isNotEmpty) ? phone : 'NA',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOrderCubit, AddOrderState>(
      listener: (context, state) async {
        if (state is AddOrderNeedsOnlinePayment) {
          final listenerContext = context;
          final addOrderCubit = listenerContext.read<AddOrderCubit>();

          // Paymob's card-flow requires `billing_data` fields (email/phone/name).
          // Your app collects them during checkout, so we inject them right before
          // starting the card payment flow.
          final shipping = state.order.shippingAddressEntity;
          final currentPaymentData = PaymentData();
          PaymentData.initialize(
            apiKey: currentPaymentData.apiKey,
            iframeId: currentPaymentData.iframeId,
            integrationCardId: currentPaymentData.integrationCardId,
            integrationMobileWalletId: currentPaymentData.integrationMobileWalletId,
            userData: _userDataFromShipping(shipping),
            style: currentPaymentData.style,
          );

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
                        S.of(listenerContext).paymentError,
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
