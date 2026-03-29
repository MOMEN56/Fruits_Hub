import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/connectivity/connection_cubit.dart';
import 'package:fruit_hub/core/connectivity/connection_status.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/checkout/domain/entities/shipping_address_entity.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/add_order_cubit/add_order_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/checkout_steps.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/checkout_steps_page_view.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  late final PageController _pageController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _floorController;
  late final TextEditingController _phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    final shippingAddress =
        context.read<CheckoutCubit>().state.orderInput.shippingAddressEntity;
    _nameController = TextEditingController(text: shippingAddress.name ?? '');
    _emailController = TextEditingController(text: shippingAddress.email ?? '');
    _addressController = TextEditingController(
      text: shippingAddress.address ?? '',
    );
    _cityController = TextEditingController(text: shippingAddress.city ?? '');
    _floorController = TextEditingController(text: shippingAddress.floor ?? '');
    _phoneController = TextEditingController(text: shippingAddress.phone ?? '');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _floorController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = context.watch<CheckoutCubit>().state;
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final topSpacing = ResponsiveLayout.isMobile(context) ? 20.0 : 28.0;

    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen:
          (previous, current) =>
              previous.currentStepIndex != current.currentStepIndex,
      listener: (_, state) {
        _pageController.animateToPage(
          state.currentStepIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: topSpacing),
                CheckoutSteps(
                  onTap: _handleStepTapped,
                  currentPageIndex: checkoutState.currentStepIndex,
                ),
                Expanded(
                  child: CheckoutStepsPageView(
                    addressAutovalidateMode:
                        checkoutState.addressAutovalidateMode,
                    addressController: _addressController,
                    cityController: _cityController,
                    emailController: _emailController,
                    floorController: _floorController,
                    formKey: _formKey,
                    nameController: _nameController,
                    pageController: _pageController,
                    phoneController: _phoneController,
                  ),
                ),
                CustomButton(
                  onPressed: _handlePrimaryAction,
                  text: checkoutState.nextButtonText,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleStepTapped(int targetStepIndex) async {
    final checkoutCubit = context.read<CheckoutCubit>();
    final currentStepIndex = checkoutCubit.state.currentStepIndex;

    if (targetStepIndex < currentStepIndex) {
      checkoutCubit.moveToStep(targetStepIndex);
      return;
    }

    if (targetStepIndex == currentStepIndex) {
      return;
    }

    await _handlePrimaryAction();
  }

  Future<void> _handlePrimaryAction() async {
    switch (context.read<CheckoutCubit>().state.currentStepIndex) {
      case 0:
        _continueFromShippingStep();
        return;
      case 1:
        _continueFromAddressStep();
        return;
      case 2:
        final isConnected = await _ensureInternetConnection();
        if (!isConnected || !mounted) {
          return;
        }
        context.read<AddOrderCubit>().submitOrder(
          order: context.read<CheckoutCubit>().state.orderInput,
        );
        return;
    }
  }

  void _continueFromShippingStep() {
    final checkoutCubit = context.read<CheckoutCubit>();
    if (!checkoutCubit.state.canContinueFromShipping) {
      buildSnackBar(context, S.of(context).pleaseSelectPaymentMethod);
      return;
    }

    checkoutCubit.moveToNextStep();
  }

  void _continueFromAddressStep() {
    if (!_formKey.currentState!.validate()) {
      context.read<CheckoutCubit>().enableAddressAutovalidate();
      return;
    }

    context.read<CheckoutCubit>().saveShippingAddress(
      ShippingAddressEntity(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        floor: _floorController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
    context.read<CheckoutCubit>().moveToNextStep();
  }

  Future<bool> _ensureInternetConnection() async {
    final connectionCubit = context.read<ConnectionCubit>();
    await connectionCubit.refresh();
    if (!mounted) {
      return false;
    }

    final connectionStatus = connectionCubit.state;
    if (connectionStatus == ConnectionStatus.online) {
      return true;
    }

    final l10n = S.of(context);
    buildSnackBar(
      context,
      l10n.checkInternetConnection,
      title: switch (connectionStatus) {
        ConnectionStatus.noNetwork => l10n.noNetworkTitle,
        ConnectionStatus.connectedNoInternet => l10n.noInternetTitle,
        ConnectionStatus.checking || ConnectionStatus.online =>
          l10n.noInternetTitle,
      },
    );
    return false;
  }
}
