import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/features/auth/presentation/views/signin_view.dart';

class OnBoardingPageViewItem extends StatelessWidget {
  const OnBoardingPageViewItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundimage,
    required this.isVisible,
  });

  final Widget title;
  final String subtitle;
  final String image;
  final String backgroundimage;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight =
            (constraints.maxHeight * 0.56).clamp(260.0, 460.0).toDouble();
        final subtitleHorizontalPadding =
            (constraints.maxWidth * 0.14).clamp(24.0, 72.0).toDouble();

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(backgroundimage, fit: BoxFit.fill),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SvgPicture.asset(image, fit: BoxFit.contain),
                      ),
                      if (isVisible)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              Prefs.setBool('KisOnBoardingViewSeen', true);
                              Navigator.of(
                                context,
                              ).popAndPushNamed(SigninView.routeName);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'تخط',
                                style: TextStyle(
                                  color: Color(0xFF949D9E),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                title,
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: subtitleHorizontalPadding,
                  ),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF4E5456),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
