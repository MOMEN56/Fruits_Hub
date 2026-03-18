import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFDCDEDE))),
        const SizedBox(width: 18),
        Text(
          S.of(context).orLabel,
          textAlign: TextAlign.center,
          style: TextStyles.semiBold16,
        ),
        const SizedBox(width: 18),
        const Expanded(child: Divider(color: Color(0xFFDCDEDE))),
      ],
    );
  }
}
