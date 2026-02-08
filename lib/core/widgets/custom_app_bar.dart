import 'package:flutter/material.dart';
import 'package:fruit_hub/core/notification_widget.dart';

import '../utils/app_text_styles.dart';

AppBar buildAppBar(
  context, {
  required String title,
  bool showBackButton = true,
  bool showNotification = true,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    actions: [
      if (showNotification)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: const NotificationWidget(),
        ),
    ],
    leading: Visibility(
      visible: showBackButton,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    ),
    centerTitle: true,
    title: Text(title, textAlign: TextAlign.center, style: TextStyles.bold19),
  );
}
