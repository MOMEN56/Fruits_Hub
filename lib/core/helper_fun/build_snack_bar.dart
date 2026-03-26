import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/generated/l10n.dart';

enum AppSnackBarType { success, error }

void buildSnackBar(
  BuildContext context,
  String message, {
  AppSnackBarType type = AppSnackBarType.error,
  String? title,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 2),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
        duration: duration,
        content: _AppSnackBarContent(
          title: title ?? _defaultTitle(type),
          message: message,
          type: type,
          actionLabel: actionLabel,
          onAction:
              onAction == null
                  ? null
                  : () {
                    messenger.hideCurrentSnackBar();
                    onAction();
                  },
        ),
      ),
    );
}

String _defaultTitle(AppSnackBarType type) {
  return switch (type) {
    AppSnackBarType.error => S.current.titleError,
    AppSnackBarType.success => S.current.titleSuccess,
  };
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({
    required this.title,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final AppSnackBarType type;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(type);
    final darkAccentColor = _shadeColor(accentColor, -0.12);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -18,
              bottom: -18,
              child: _SnackBarBubbleCluster(
                color: darkAccentColor.withValues(alpha: 0.34),
              ),
            ),
            Positioned(
              right: 18,
              top: -14,
              child: _SnackBarStatusBadge(
                backgroundColor: darkAccentColor,
                icon: _icon(type),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (actionLabel != null && onAction != null) ...[
                      _SnackBarActionButton(
                        label: actionLabel!,
                        accentColor: accentColor,
                        onPressed: onAction!,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Directionality(
                        textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                isRtl
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  title,
                                  textAlign:
                                      isRtl ? TextAlign.right : TextAlign.left,
                                  style: TextStyles.bold16.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign:
                                      isRtl ? TextAlign.right : TextAlign.left,
                                  style: TextStyles.regular13.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnackBarActionButton extends StatelessWidget {
  const _SnackBarActionButton({
    required this.label,
    required this.accentColor,
    required this.onPressed,
  });

  final String label;
  final Color accentColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        minimumSize: const Size(92, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyles.semiBold13.copyWith(color: accentColor, height: 1.2),
      ),
    );
  }
}

class _SnackBarStatusBadge extends StatelessWidget {
  const _SnackBarStatusBadge({
    required this.backgroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

class _SnackBarBubbleCluster extends StatelessWidget {
  const _SnackBarBubbleCluster({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 62,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: 44,
            bottom: 4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 60,
            bottom: 24,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _accentColor(AppSnackBarType type) {
  return switch (type) {
    AppSnackBarType.success => AppColors.primaryColor,
    AppSnackBarType.error => const Color(0xFFC62828),
  };
}

Color _shadeColor(Color color, double amount) {
  final hslColor = HSLColor.fromColor(color);
  final adjustedLightness = (hslColor.lightness + amount).clamp(0.0, 1.0);
  return hslColor.withLightness(adjustedLightness).toColor();
}

IconData _icon(AppSnackBarType type) {
  return switch (type) {
    AppSnackBarType.success => Icons.check_rounded,
    AppSnackBarType.error => Icons.error_outline_rounded,
  };
}
