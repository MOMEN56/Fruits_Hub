class UserOrderProductEntity {
  final String name;
  final String code;
  final String? imageUrl;
  final double price;
  final int quantity;

  const UserOrderProductEntity({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory UserOrderProductEntity.fromJson(Map<String, dynamic> json) {
    return UserOrderProductEntity(
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      imageUrl: json['imageUrl']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}
