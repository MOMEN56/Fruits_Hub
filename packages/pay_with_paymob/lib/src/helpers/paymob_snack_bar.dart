import 'package:awesome_snackbar_content/src/awesome_snackbar_content.dart'
    as awesome_snack;
import 'package:awesome_snackbar_content/src/content_type.dart'
    as awesome_content;
import 'package:flutter/material.dart';

enum PaymobSnackBarType { success, error }

void showPaymobSnackBar(
  BuildContext context,
  String message, {
  PaymobSnackBarType type = PaymobSnackBarType.error,
  String? title,
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
        content: awesome_snack.AwesomeSnackbarContent(
          title: title ?? _defaultTitle(type),
          message: message,
          contentType: type == PaymobSnackBarType.error
              ? awesome_content.ContentType.failure
              : awesome_content.ContentType.success,
        ),
      ),
    );
}

String _defaultTitle(PaymobSnackBarType type) {
  return switch (type) {
    PaymobSnackBarType.error => 'Error',
    PaymobSnackBarType.success => 'Success',
  };
}
