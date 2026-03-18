import 'package:flutter/material.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/step_item.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({
    super.key,
    required this.currentPageIndex,
    required this.onTap,
  });

  final int currentPageIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final steps = getSteps(S.of(context));

    return Row(
      children: List.generate(steps.length, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              onTap(index);
            },
            child: StepItem(
              isActive: index <= currentPageIndex,
              index: (index + 1).toString(),
              text: steps[index],
            ),
          ),
        );
      }),
    );
  }
}

List<String> getSteps(S l10n) {
  return [l10n.shipping, l10n.address, l10n.payment];
}
