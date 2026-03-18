import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:fruit_hub/generated/l10n.dart';

enum AppSnackBarType { success, error }

void buildSnackBar(
  BuildContext context,
  String message, {
  AppSnackBarType type = AppSnackBarType.error,
  String? title,
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
        padding: EdgeInsets.zero,
        duration: duration,
        content: AwesomeSnackbarContent(
          title: title ?? _defaultTitle(type),
          message: message,
          contentType:
              type == AppSnackBarType.error
                  ? ContentType.failure
                  : ContentType.success,
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
