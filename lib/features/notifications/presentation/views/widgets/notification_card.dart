import 'package:flutter/material.dart';
import 'package:fruit_hub/features/notifications/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    this.onOpenOrders,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback? onOpenOrders;

  @override
  Widget build(BuildContext context) {
    final title = notification.titleAr.trim().isEmpty
        ? 'تحديث الطلب'
        : notification.titleAr.trim();
    final message = _resolveNotificationMessage(notification);
    final createdAtLabel = _formatRelativeTime(notification.createdAt);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!notification.isRead)
                  const CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xFF4CAF50),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4A5560)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  createdAtLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A96A3),
                  ),
                ),
                const Spacer(),
                if (onOpenOrders != null)
                  TextButton(
                    onPressed: onOpenOrders,
                    child: const Text('عرض الطلبات'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _resolveNotificationMessage(NotificationEntity notification) {
    final explicitMessage = notification.messageAr.trim();
    if (explicitMessage.isNotEmpty) {
      return explicitMessage;
    }

    final normalizedStatus = (notification.status ?? '').trim().toLowerCase();
    switch (normalizedStatus) {
      case 'pending':
        return 'يتم المراجعة';
      case 'accepted':
        return 'يتم تحضيره';
      case 'delivered':
      case 'completed':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'لديك إشعار جديد';
    }
  }

  String _formatRelativeTime(DateTime value) {
    final now = DateTime.now();
    final localDate = value.toLocal();
    final diff = now.difference(localDate);

    if (diff.inSeconds < 60) {
      return 'الآن';
    }
    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    }
    if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    }
    if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    }

    String pad(int number) => number.toString().padLeft(2, '0');
    return '${localDate.year}-${pad(localDate.month)}-${pad(localDate.day)}';
  }
}
