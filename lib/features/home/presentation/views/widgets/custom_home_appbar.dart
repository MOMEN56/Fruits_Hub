import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruit_hub/core/notification_widget.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/utils/widgets/custom_network_image.dart';
import 'package:fruit_hub/features/auth/domain/entites/user_entity.dart';
import 'package:fruit_hub/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:fruit_hub/features/auth/presentation/views/signin_view.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CustomHomeAppbar extends StatelessWidget {
  const CustomHomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isMobile = ResponsiveLayout.isMobile(context);
    final avatarSize = isMobile ? 44.0 : 52.0;
    final user =
        getIt<CurrentUserService>().getCurrentUser() ??
        UserEntity(name: l10n.user, email: '', uId: '');
    final resolvedPhotoUrl = _resolvedPhotoUrl(user);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: isMobile ? 10 : 14,
      minLeadingWidth: avatarSize,
      trailing: const NotificationWidget(),
      leading: GestureDetector(
        onTap: () {
          _showProfileActionsSheet(
            context,
            user: user,
            resolvedPhotoUrl: resolvedPhotoUrl,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(avatarSize / 2),
          child: SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: _buildProfileAvatar(resolvedPhotoUrl: resolvedPhotoUrl),
          ),
        ),
      ),
      title: Text(
        l10n.goodMorning,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyles.regular16.copyWith(color: const Color(0xFF949D9E)),
      ),
      subtitle: Text(
        user.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyles.bold16,
      ),
    );
  }

  String _resolvedPhotoUrl(UserEntity user) {
    final storedPhotoUrl = user.photoUrl.trim();
    if (storedPhotoUrl.isNotEmpty) {
      return storedPhotoUrl;
    }

    return (FirebaseAuth.instance.currentUser?.photoURL ?? '').trim();
  }

  Widget _buildProfileAvatar({required String resolvedPhotoUrl}) {
    if (resolvedPhotoUrl.isEmpty) {
      return Image.asset(Assets.assetsImagesProfileImage, fit: BoxFit.cover);
    }

    return CustomNetworkImage(
      imageUrl: resolvedPhotoUrl,
      fit: BoxFit.cover,
      fallback: Image.asset(Assets.assetsImagesProfileImage, fit: BoxFit.cover),
    );
  }

  Future<void> _showProfileActionsSheet(
    BuildContext context, {
    required UserEntity user,
    required String resolvedPhotoUrl,
  }) async {
    final l10n = S.of(context);
    final rootContext = context;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9E1DD),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: _buildProfileAvatar(
                          resolvedPhotoUrl: resolvedPhotoUrl,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name.isNotEmpty ? user.name : l10n.user,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.bold16,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email.isNotEmpty ? user.email : l10n.noEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.regular13.copyWith(
                              color: const Color(0xFF7B8A87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEECEC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFD92D20),
                    ),
                  ),
                  title: Text(
                    l10n.signOut,
                    style: TextStyles.semiBold16.copyWith(
                      color: const Color(0xFFD92D20),
                    ),
                  ),
                  subtitle: Text(
                    l10n.signOutDescription,
                    style: TextStyles.regular13.copyWith(
                      color: const Color(0xFFB54708),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _signOut(rootContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await getIt<SignOutUseCase>().call();

    if (!context.mounted) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(SigninView.routeName, (route) => false);
  }
}
