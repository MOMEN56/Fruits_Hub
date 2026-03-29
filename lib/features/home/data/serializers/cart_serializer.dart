import 'dart:convert';

import 'package:fruit_hub/core/models/product_model.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';

class CartSerializer {
  const CartSerializer();

  String encode(CartEntity cartEntity) {
    final cartJson =
        cartEntity.cartItems
            .map(
              (item) => {
                'quantity': item.quantity,
                'product': _productToJson(item.productEntity),
              },
            )
            .toList();
    return jsonEncode(cartJson);
  }

  CartEntity? decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;

      final restoredItems =
          decoded
              .whereType<Map>()
              .map((item) => _cartItemFromJson(Map<String, dynamic>.from(item)))
              .whereType<CarItemEntity>()
              .toList();
      return CartEntity(restoredItems);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _productToJson(ProductEntity productEntity) {
    return ProductModel(
      name: productEntity.name,
      code: productEntity.code,
      description: productEntity.description,
      price: productEntity.price,
      sellingCount: productEntity.sellingCount,
      isFeatured: productEntity.isFeatured,
      imageUrl: productEntity.imageUrl,
      expirationsMonths: productEntity.expirationsMonths,
      isOrganic: productEntity.isOrganic,
      numberOfCalories: productEntity.numberOfCalories,
      unitAmount: productEntity.unitAmount,
      reviews: null,
    ).toJson();
  }

  CarItemEntity? _cartItemFromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    final quantity = json['quantity'];
    if (productJson is! Map || quantity is! num) return null;

    final product = ProductModel.fromJson(
      Map<String, dynamic>.from(productJson),
    ).toEntity();
    return CarItemEntity(productEntity: product, quantity: quantity.toInt());
  }
}
