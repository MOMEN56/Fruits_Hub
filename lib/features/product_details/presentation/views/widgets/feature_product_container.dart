import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';

import 'package:flutter/material.dart';

class FeatureProductContainer extends StatelessWidget {
  const FeatureProductContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.borderColor = const Color(0xFFF1F1F5),
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent, // خلفية شفافة
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor, // لون الإطار
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // النصوص
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF23AA49),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF969899),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  height: 1.7,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // الأيقونة / الصورة
          SizedBox(height: 36, width: 36, child: icon),
        ],
      ),
    );
  }
}
