import 'package:flutter/material.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/active_step_item.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/inactive_step_item.dart';

class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.index,
    required this.text,
    required this.isActive,
  });
  final String index, text;

  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: InActiveStepItem(index: index, text: text),
      secondChild: ActiveStepItem(text: text),
      crossFadeState:
          isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 300),
    );
  }
}
