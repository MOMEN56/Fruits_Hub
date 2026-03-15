import 'package:flutter/material.dart';

String shortOrderId(String orderId) {
  if (orderId.length <= 8) return orderId;
  return orderId.substring(orderId.length - 8);
}

String paymentMethodLabel(String method) {
  final normalized = method.toLowerCase();
  if (normalized.contains('cash')) return 'كاش';
  if (normalized.contains('online')) return 'أونلاين';
  return method;
}

String statusLabel(String status) {
  final normalized = status.toLowerCase();
  return switch (normalized) {
    'pending' => 'قيد المراجعة',
    'accepted' => 'يتم تحضيره',
    'completed' || 'delivered' => 'تم التوصيل',
    'cancelled' => 'ملغي',
    _ => status,
  };
}

String detailsStatusLabel(String status) => 'الحالة: ${statusLabel(status)}';

Color statusBadgeBackgroundColor(String status) {
  final normalized = status.toLowerCase();
  return switch (normalized) {
    'pending' => const Color(0xFFFFF3E0),
    'accepted' => const Color(0xFFE3F2FD),
    'completed' || 'delivered' => const Color(0xFFE8F5E9),
    'cancelled' => const Color(0xFFFFEBEE),
    _ => const Color(0xFFECEFF1),
  };
}

Color statusBadgeTextColor(String status) {
  final normalized = status.toLowerCase();
  return switch (normalized) {
    'pending' => const Color(0xFFB26A00),
    'accepted' => const Color(0xFF1565C0),
    'completed' || 'delivered' => const Color(0xFF2E7D32),
    'cancelled' => const Color(0xFFC62828),
    _ => const Color(0xFF546E7A),
  };
}

String formatOrderDate(DateTime date, {bool includeTime = false}) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  if (!includeTime) {
    return '$day/$month/$year';
  }

  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}
