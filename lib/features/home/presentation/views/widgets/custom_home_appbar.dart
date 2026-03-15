import 'package:flutter/material.dart';
import 'package:fruit_hub/core/helper_fun/get_user.dart';
import 'package:fruit_hub/core/notification_widget.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';

class CustomHomeAppbar extends StatelessWidget {
  const CustomHomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final avatarSize = isMobile ? 44.0 : 52.0;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: isMobile ? 10 : 14,
      minLeadingWidth: avatarSize,
      trailing: const NotificationWidget(),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: Image.asset(
          Assets.assetsImagesProfileImage,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        'صباح الخير !..',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyles.regular16.copyWith(color: const Color(0xFF949D9E)),
      ),
      subtitle: Text(
        getUser().name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyles.bold16,
      ),
    );
  }
}
