class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.titleAr,
    required this.messageAr,
    required this.isRead,
    required this.createdAt,
    this.userId,
    this.orderId,
    this.status,
  });

  final String id;
  final String type;
  final String titleAr;
  final String messageAr;
  final bool isRead;
  final DateTime createdAt;
  final String? userId;
  final String? orderId;
  final String? status;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: (json['id'] ?? json['notification_id'] ?? '').toString(),
      type: (json['type'] ?? 'manual').toString(),
      titleAr: (json['title_ar'] ?? json['title'] ?? '').toString(),
      messageAr: (json['message_ar'] ?? json['message'] ?? '').toString(),
      isRead: _toBool(json['is_read']),
      createdAt: _toDateTime(json['created_at']),
      userId: _toNullableString(json['user_id']),
      orderId: _toNullableString(json['order_id']),
      status: _toNullableString(json['status']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final raw = (value ?? '').toString().toLowerCase();
    return raw == 'true' || raw == '1';
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    final parsed = DateTime.tryParse((value ?? '').toString());
    return parsed ?? DateTime.now();
  }

  static String? _toNullableString(dynamic value) {
    final normalized = (value ?? '').toString().trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return null;
    }
    return normalized;
  }
}
