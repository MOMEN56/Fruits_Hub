import 'package:flutter/material.dart';

class HighlightedOrderBanner extends StatelessWidget {
  const HighlightedOrderBanner({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'تم فتح الإشعار الخاص بالطلب رقم: $orderId',
      ),
    );
  }
}
