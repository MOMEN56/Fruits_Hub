import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/products_sort_option.dart';

Future<void> showProductsSortBottomSheet({
  required BuildContext context,
  required ProductsSortOption selectedOption,
  required ValueChanged<ProductsSortOption> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ترتيب المنتجات',
                style: TextStyles.bold16.copyWith(color: const Color(0xFF0C0D0D)),
              ),
              const SizedBox(height: 12),
              ...ProductsSortOption.values.map(
                (option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option.label,
                    style: TextStyles.regular13.copyWith(
                      color:
                          option == selectedOption
                              ? const Color(0xFF1B5E37)
                              : const Color(0xFF0C0D0D),
                    ),
                  ),
                  trailing:
                      option == selectedOption
                          ? const Icon(Icons.check_rounded, color: Color(0xFF1B5E37))
                          : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(option);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
