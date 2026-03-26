import 'package:equatable/equatable.dart';

class DashboardOrderEntity extends Equatable {
  const DashboardOrderEntity({
    required this.identifierField,
    required this.identifierValue,
    required this.orderId,
    required this.userId,
    required this.totalPrice,
    required this.itemsCount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
  });

  final String identifierField;
  final Object identifierValue;
  final String orderId;
  final String userId;
  final double totalPrice;
  final int itemsCount;
  final String paymentMethod;
  final String status;
  final DateTime? createdAt;
  final String? shippingAddress;

  String get orderKey => '$identifierField:$identifierValue';

  String get shortOrderId {
    if (orderId.length <= 8) {
      return orderId;
    }
    return orderId.substring(orderId.length - 8);
  }

  DashboardOrderEntity copyWith({String? status}) {
    return DashboardOrderEntity(
      identifierField: identifierField,
      identifierValue: identifierValue,
      orderId: orderId,
      userId: userId,
      totalPrice: totalPrice,
      itemsCount: itemsCount,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
      shippingAddress: shippingAddress,
    );
  }

  static DashboardOrderEntity? fromJson(Map<String, dynamic> json) {
    try {
      final orderIdRaw = (json['order_id'] ?? '').toString().trim();
      final fallbackId = json['id'];
      final hasOrderId = orderIdRaw.isNotEmpty;

      if (!hasOrderId && fallbackId == null) {
        return null;
      }

      final userId = (json['u_id'] ?? '').toString().trim();
      if (userId.isEmpty) {
        return null;
      }

      final createdAt = _parseCreatedAt(json['created_at']);

      return DashboardOrderEntity(
        identifierField: hasOrderId ? 'order_id' : 'id',
        identifierValue: hasOrderId ? orderIdRaw : fallbackId as Object,
        orderId: hasOrderId ? orderIdRaw : fallbackId.toString(),
        userId: userId,
        totalPrice: _toDouble(json['total_price']),
        itemsCount: _extractItemsCount(json['order_products']),
        paymentMethod: (json['payment_method'] ?? '').toString(),
        status: _normalizeStatus((json['status'] ?? '').toString()),
        createdAt: createdAt,
        shippingAddress: _extractShippingAddress(json['shipping_address']),
      );
    } catch (_) {
      return null;
    }
  }

  static int _extractItemsCount(dynamic rawProducts) {
    if (rawProducts is! List) {
      return 0;
    }

    var itemsCount = 0;
    for (final rawItem in rawProducts.whereType<Map>()) {
      final item = Map<String, dynamic>.from(rawItem);
      final quantity = _toInt(item['quantity']);
      itemsCount += quantity > 0 ? quantity : 0;
    }

    if (itemsCount == 0) {
      return rawProducts.length;
    }
    return itemsCount;
  }

  static DateTime? _parseCreatedAt(dynamic rawCreatedAt) {
    if (rawCreatedAt is String) {
      return DateTime.tryParse(rawCreatedAt);
    }
    if (rawCreatedAt is DateTime) {
      return rawCreatedAt;
    }
    return null;
  }

  static String? _extractShippingAddress(dynamic rawShippingAddress) {
    if (rawShippingAddress is! Map) {
      return null;
    }

    final shippingMap = Map<String, dynamic>.from(rawShippingAddress);
    final parts = [
      shippingMap['address']?.toString(),
      shippingMap['city']?.toString(),
      shippingMap['floor']?.toString(),
    ].where((part) => part != null && part.trim().isNotEmpty).toList();

    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' - ');
  }

  static String _normalizeStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'pending';
    }
    if (normalized == 'completed') {
      return 'delivered';
    }
    return normalized;
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  @override
  List<Object?> get props => [
    identifierField,
    identifierValue,
    orderId,
    userId,
    totalPrice,
    itemsCount,
    paymentMethod,
    status,
    createdAt,
    shippingAddress,
  ];
}

class UserOrdersGroupEntity extends Equatable {
  const UserOrdersGroupEntity({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.orders,
  });

  final String userId;
  final String userName;
  final String userEmail;
  final List<DashboardOrderEntity> orders;

  String get displayName => userName.isEmpty ? 'Unknown user' : userName;

  String get displayEmail => userEmail.isEmpty ? userId : userEmail;

  String get avatarInitial {
    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      return '?';
    }
    return trimmedName.substring(0, 1).toUpperCase();
  }

  DateTime? get latestCreatedAt {
    DateTime? latest;
    for (final order in orders) {
      final createdAt = order.createdAt;
      if (createdAt == null) {
        continue;
      }
      if (latest == null || createdAt.isAfter(latest)) {
        latest = createdAt;
      }
    }
    return latest;
  }

  UserOrdersGroupEntity filterByStatus(String status) {
    return UserOrdersGroupEntity(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      orders: orders.where((order) => order.status == status).toList(),
    );
  }

  @override
  List<Object?> get props => [userId, userName, userEmail, orders];
}
