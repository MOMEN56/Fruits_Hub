import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';

class OrderProductModel {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String code;

  OrderProductModel({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.code,
  });
  factory OrderProductModel.fromEntity({
    required CarItemEntity cartItemEntity,
  }) {
    return OrderProductModel(
      name: cartItemEntity.productEntity.name,
      imageUrl: cartItemEntity.productEntity.imageUrl!,
      price: cartItemEntity.productEntity.price.toDouble(),
      quantity: cartItemEntity.quantity,
      code: cartItemEntity.productEntity.code,
    );
  }
  toJson() {
    return {
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
