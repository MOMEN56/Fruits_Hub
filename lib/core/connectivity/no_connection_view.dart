import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/generated/l10n.dart';

class NoConnectionView extends StatelessWidget {
  const NoConnectionView({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final imageWidth = (screenWidth * 0.52).clamp(180.0, 260.0).toDouble();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding + 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.assetsImagesNointernet,
              width: imageWidth,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 28),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.bold19.copyWith(color: const Color(0xFF0C0D0D)),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.regular13.copyWith(
                color: const Color(0xFF6C7475),
                height: 1.6,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: l10n.retry,
                width: (screenWidth * 0.6).clamp(180.0, 260.0).toDouble(),
                onPressed: onRetry!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
