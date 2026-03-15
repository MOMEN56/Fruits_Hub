import 'package:fruit_hub/features/checkout/domain/entites/user_order_product_entity.dart';

class UserOrderEntity {
  final String orderId;
  final double totalPrice;
  final String paymentMethod;
  final String status;
  final DateTime? createdAt;
  final int itemsCount;
  final String? firstProductName;
  final String? firstProductImageUrl;
  final String? shippingAddress;
  final List<UserOrderProductEntity> products;

  const UserOrderEntity({
    required this.orderId,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.itemsCount,
    required this.products,
    this.firstProductName,
    this.firstProductImageUrl,
    this.shippingAddress,
  });

  factory UserOrderEntity.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'];
    final createdAt =
        createdAtValue is String
            ? DateTime.tryParse(createdAtValue)
            : createdAtValue is DateTime
            ? createdAtValue
            : null;

    final rawProducts = json['order_products'];
    final products =
        rawProducts is List
            ? rawProducts
                .whereType<Map>()
                .map(
                  (e) => UserOrderProductEntity.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
            : <UserOrderProductEntity>[];

    final firstProduct = products.isNotEmpty ? products.first : null;

    String? shippingAddress;
    final rawShippingAddress = json['shipping_address'];
    if (rawShippingAddress is Map) {
      final shippingAddressMap = Map<String, dynamic>.from(rawShippingAddress);
      final addressParts = [
        shippingAddressMap['address']?.toString(),
        shippingAddressMap['city']?.toString(),
        shippingAddressMap['floor']?.toString(),
      ].where((element) => element != null && element.trim().isNotEmpty).toList();
      if (addressParts.isNotEmpty) {
        shippingAddress = addressParts.join(' - ');
      }
    }

    return UserOrderEntity(
      orderId: (json['order_id'] ?? '').toString(),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      paymentMethod: (json['payment_method'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      createdAt: createdAt,
      itemsCount: products.length,
      firstProductName: firstProduct?.name,
      firstProductImageUrl: firstProduct?.imageUrl,
      shippingAddress: shippingAddress,
      products: products,
    );
  }
}
