import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/features/auth/presentation/views/login_view.dart';

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
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: Stack(
            children: [
              // الخلفية
              Positioned.fill(
                child: SvgPicture.asset(backgroundimage, fit: BoxFit.fill),
              ),
              // الصورة الرئيسية (محاذاة Bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(image),
              ),
              // زر "تخط"
              Visibility(
                visible: isVisible,
                child: GestureDetector(
                  onTap: () {
                    Prefs.setBool('KisOnBoardingViewSeen', true);
                    Navigator.of(context).popAndPushNamed(LoginView.routeName);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'تخط',
                      style: TextStyle(color: Color(0xFF949D9E), fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // العنوان
        title,
        const SizedBox(height: 64),

        // الـ subtitle مع padding أكبر
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37),
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
        const SizedBox(height: 24), // مسافة بعد الـ subtitle
      ],
    );
  }
}
