import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';

class InActiveStepItem extends StatelessWidget {
  const InActiveStepItem({super.key, required this.index, required this.text});
  final String index;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 10,
          backgroundColor: Color(0xFFF2F3F3),
          child: Text('2', style: TextStyles.semiBold13),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyles.semiBold13.copyWith(color: const Color(0xFFAAAAAA)),
        ),
      ],
    );
  }
}
