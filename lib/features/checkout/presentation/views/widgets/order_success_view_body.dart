import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/animated_order_success_badge.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';

class OrderSuccessViewBody extends StatelessWidget {
  const OrderSuccessViewBody({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  kTopPaddding,
                ),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    children: [
                      const Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AnimatedOrderSuccessBadge(),
                          const SizedBox(height: 28),
                          Text(
                            'تم بنجاح !',
                            style: TextStyles.bold23.copyWith(
                              color: const Color(0xFF0C0D0D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'رقم الطلب: ${_formatOrderNumber(orderId)}',
                            textAlign: TextAlign.center,
                            style: TextStyles.regular16.copyWith(
                              color: const Color(0xFF6C7475),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'تتبع الطلب',
                        height: 56,
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            MainView.routeName,
                            (route) => false,
                            arguments: 3,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            MainView.routeName,
                            (route) => false,
                          );
                        },
                        child: Text(
                          'الرئيسية',
                          style: TextStyles.bold16.copyWith(
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatOrderNumber(String rawOrderId) {
    final normalized = rawOrderId.replaceAll('-', '').toUpperCase().trim();
    if (normalized.isEmpty) {
      return '#----';
    }
    final visiblePart =
        normalized.length > 10 ? normalized.substring(0, 10) : normalized;
    return '#$visiblePart';
  }
}
