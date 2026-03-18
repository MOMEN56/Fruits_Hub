import 'package:flutter/material.dart';
import 'package:fruit_hub/core/widgets/custom_text_field.dart';
import 'package:fruit_hub/generated/l10n.dart';

class AddressInputSection extends StatelessWidget {
  const AddressInputSection({
    super.key,
    required this.addressController,
    required this.autovalidateMode,
    required this.cityController,
    required this.emailController,
    required this.floorController,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
  });

  final TextEditingController addressController;
  final AutovalidateMode autovalidateMode;
  final TextEditingController cityController;
  final TextEditingController emailController;
  final TextEditingController floorController;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: nameController,
              hintText: l10n.fullNameHint,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: emailController,
              hintText: l10n.emailHint,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: addressController,
              hintText: l10n.addressHint,
              textInputType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: cityController,
              hintText: l10n.cityHint,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: floorController,
              hintText: l10n.floorApartmentHint,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: phoneController,
              hintText: l10n.phoneHint,
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
