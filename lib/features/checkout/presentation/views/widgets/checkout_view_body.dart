import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/presentation/manger/cubit/add_order_cubit_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/checkout_steps.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/checkout_steps_page_view.dart';
import 'package:provider/provider.dart';

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  late PageController pageController;
  final ValueNotifier<AutovalidateMode> valueNotifier = ValueNotifier(
    AutovalidateMode.disabled,
  );
  int currentPageIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPageIndex = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final topSpacing = ResponsiveLayout.isMobile(context) ? 20.0 : 28.0;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: topSpacing),
              CheckoutSteps(
                onTap: (index) {
                  if (index < currentPageIndex) {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (index == currentPageIndex) {
                    return;
                  } else {
                    if (currentPageIndex == 0) {
                      if (context.read<OrderInputEntity>().payWithCash != null) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        buildSnackBar(context, 'يرجى تحديد طريقة الدفع');
                      }
                    } else if (currentPageIndex == 1) {
                      _handleAddressValidation();
                    }
                  }
                },
                pageController: pageController,
                currentPageIndex: currentPageIndex,
              ),
              Expanded(
                child: CheckoutStepsPageView(
                  valueListenable: valueNotifier,
                  pageController: pageController,
                  formKey: _formKey,
                ),
              ),
              CustomButton(
                onPressed: () {
                  if (currentPageIndex == 0) {
                    _handleShippingSectionValidation(context);
                  } else if (currentPageIndex == 1) {
                    _handleAddressValidation();
                  } else {
                    context.read<AddOrderCubit>().submitOrder(
                      order: context.read<OrderInputEntity>(),
                    );
                  }
                },
                text: getNextButtonText(currentPageIndex),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _handleShippingSectionValidation(BuildContext context) {
    if (context.read<OrderInputEntity>().payWithCash != null) {
      pageController.animateToPage(
        currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    } else {
      buildSnackBar(context, 'يرجى تحديد طريقة الدفع');
    }
  }

  String getNextButtonText(int currentPageIndex) {
    final orderEntity = context.read<OrderInputEntity>();
    switch (currentPageIndex) {
      case 0:
      case 1:
        return 'التالي';
      case 2:
        return orderEntity.payWithCash == true ? 'تأكيد الطلب' : "الدفع";
      default:
        return 'التالي';
    }
  }

  void _handleAddressValidation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      pageController.animateToPage(
        currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    } else {
      valueNotifier.value = AutovalidateMode.always;
    }
  }
}
