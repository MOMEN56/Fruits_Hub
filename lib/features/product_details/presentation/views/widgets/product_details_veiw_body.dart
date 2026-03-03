import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
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
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: kTopPaddding,
          left: kTopPaddding,
          right: kTopPaddding,
        ),
        child: CustomProductDetailsButton(
          widget: widget,
          selectedQuantity: selectedQuantity,
          height: 56,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(375, 100),
                  bottomRight: Radius.elliptical(375, 100),
                ),
              ),
              child: Center(
                child: Container(
                  width: 221,
                  height: 167,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.productEntity.imageUrl ??
                            'https://via.placeholder.com/150',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kTopPaddding,
                vertical: kTopPaddding,
              ),
              child: Column(
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
                  FeaturesProductSection(productEntity: widget.productEntity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
