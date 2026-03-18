import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/generated/l10n.dart';

class ProductsViewHeader extends StatelessWidget {
  const ProductsViewHeader({
    super.key,
    required this.productsLength,
    this.isSortActive = false,
    this.onFilterTap,
  });

  final int productsLength;
  final bool isSortActive;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Row(
      children: [
        Text(
          l10n.resultsCount(productsLength),
          textAlign: TextAlign.right,
          style: TextStyles.bold16,
        ),
        const Spacer(),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              color: isSortActive ? const Color(0xFFF3FBF6) : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color:
                      isSortActive
                          ? AppColors.primaryColor.withValues(alpha: 0.35)
                          : const Color(0x66CACECE),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: SvgPicture.asset(
              Assets.assetsImagesFiltter2,
              colorFilter: ColorFilter.mode(
                isSortActive ? AppColors.primaryColor : const Color(0xFF949D9E),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
