import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/utils/widgets/custom_network_image.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/custom_product_details_button.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/features_product_section.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/product_info_section.dart';

class ProductDetailsViewBody extends StatefulWidget {
  const ProductDetailsViewBody({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  State<ProductDetailsViewBody> createState() => _ProductDetailsViewBodyState();
}

class _ProductDetailsViewBodyState extends State<ProductDetailsViewBody> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth >= 600 ? 24.0 : 16.0;
    final heroHeight = (screenWidth * 0.82).clamp(280.0, 460.0).toDouble();
    final productImageWidth =
        (screenWidth * 0.56).clamp(220.0, 360.0).toDouble();
    final productImageHeight = productImageWidth * (167 / 221);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                height: heroHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(screenWidth, 100),
                    bottomRight: Radius.elliptical(screenWidth, 100),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: productImageWidth,
                    height: productImageHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: widget.productEntity.imageUrl ?? '',
                      fit: BoxFit.contain,
                      showLoadingIndicator: true,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: kTopPaddding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductInfoSection(
                      productEntity: widget.productEntity,
                      selectedQuantity: selectedQuantity,
                      onIncrement: () => setState(() => selectedQuantity++),
                      onDecrement: () {
                        if (selectedQuantity > 1) {
                          setState(() => selectedQuantity--);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    FeaturesProductSection(productEntity: widget.productEntity),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: kTopPaddding,
          ),
          child: CustomProductDetailsButton(
            widget: widget,
            selectedQuantity: selectedQuantity,
            height: 56,
          ),
        ),
      ),
    );
  }
}
