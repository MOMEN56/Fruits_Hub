import 'package:flutter/material.dart';
import 'package:fruit_hub/features/checkout/presentation/views/address_input_section.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/payment_section.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/shipping_section.dart';

class CheckoutStepsPageView extends StatelessWidget {
  const CheckoutStepsPageView({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.addressAutovalidateMode,
    required this.addressController,
    required this.cityController,
    required this.emailController,
    required this.floorController,
    required this.nameController,
    required this.phoneController,
  });

  final GlobalKey<FormState> formKey;
  final PageController pageController;
  final AutovalidateMode addressAutovalidateMode;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController emailController;
  final TextEditingController floorController;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: getPages().length,
        itemBuilder: (context, index) {
          return getPages()[index];
        },
      ),
    );
  }

  List<Widget> getPages() {
    return [
      const ShippingSection(),
      AddressInputSection(
        addressController: addressController,
        autovalidateMode: addressAutovalidateMode,
        cityController: cityController,
        emailController: emailController,
        floorController: floorController,
        formKey: formKey,
        nameController: nameController,
        phoneController: phoneController,
      ),
      const PaymentSection(),
    ];
  }
}
