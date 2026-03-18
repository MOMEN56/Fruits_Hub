import 'package:flutter/material.dart';
import 'package:fruit_hub/generated/l10n.dart';

class NotificationsErrorState extends StatelessWidget {
  const NotificationsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(S.of(context).retry),
          ),
        ],
      ),
    );
  }
}
