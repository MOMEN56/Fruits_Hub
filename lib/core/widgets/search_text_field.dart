import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/products_sort_option.dart';
import 'package:fruit_hub/core/widgets/products_sort_bottom_sheet.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.selectedSortOption = ProductsSortOption.none,
    this.onSortSelected,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ProductsSortOption selectedSortOption;
  final ValueChanged<ProductsSortOption>? onSortSelected;

  @override
  Widget build(BuildContext context) {
    final isSortActive = selectedSortOption != ProductsSortOption.none;

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 9,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          prefixIcon: SizedBox(
            width: 20,
            child: Center(
              child: SvgPicture.asset(Assets.assetsImagesSearchIcon),
            ),
          ),
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap:
                onSortSelected == null
                    ? null
                    : () {
                      showProductsSortBottomSheet(
                        context: context,
                        selectedOption: selectedSortOption,
                        onSelected: onSortSelected!,
                      );
                    },
            child: SizedBox(
              width: 20,
              child: Center(
                child: SvgPicture.asset(
                  Assets.assetsImagesFilterImage,
                  colorFilter: ColorFilter.mode(
                    isSortActive
                        ? const Color(0xFF1B5E37)
                        : const Color(0xFF949D9E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          hintStyle: TextStyles.regular13.copyWith(color: const Color(0xFF949D9E)),
          hintText: 'ابحث عن...',
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          filled: true,
          fillColor: const Color(0xFFF9FAFA),
          border: buildBorder(),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F5)),
    );
  }
}
