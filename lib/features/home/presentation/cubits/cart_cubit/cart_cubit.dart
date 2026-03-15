import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/models/product_model.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:flutter/foundation.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    _hydrateCartFromStorage();
  }

  CartEntity cartEntity = CartEntity([]);

  Future<void> _hydrateCartFromStorage() async {
    final rawCart = Prefs.getString(kCartData);
    if (rawCart.isEmpty) return;

    try {
      final decoded = jsonDecode(rawCart);
      if (decoded is! List) return;

      final restoredItems =
          decoded
              .whereType<Map>()
              .map((item) => _cartItemFromJson(Map<String, dynamic>.from(item)))
              .whereType<CarItemEntity>()
              .toList();

      cartEntity = CartEntity(restoredItems);
      emit(CartHydrated());
    } catch (_) {
      await Prefs.setString(kCartData, '');
    }
  }

  Map<String, dynamic> _productToJson(ProductEntity product) {
    return ProductModel(
      name: product.name,
      code: product.code,
      description: product.description,
      price: product.price,
      sellingCount: product.sellingCount,
      isFeatured: product.isFeatured,
      imageUrl: product.imageUrl,
      expirationsMonths: product.expirationsMonths,
      isOrganic: product.isOrganic,
      numberOfCalories: product.numberOfCalories,
      unitAmount: product.unitAmount,
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

  Future<void> _persistCart() async {
    final cartJson =
        cartEntity.cartItems
            .map(
              (item) => {
                'quantity': item.quantity,
                'product': _productToJson(item.productEntity),
              },
            )
            .toList();
    await Prefs.setString(kCartData, jsonEncode(cartJson));
  }

  Future<void> addProduct(ProductEntity productEntity, {int quantity = 1}) async {
    if (quantity <= 0) return;

    final isProductExist = cartEntity.isExis(productEntity);
    if (isProductExist) {
      final carItem = cartEntity.getCarItem(productEntity);
      carItem.quantity += quantity;
    } else {
      final carItem = CarItemEntity(
        productEntity: productEntity,
        quantity: quantity,
      );
      cartEntity.addCartItem(carItem);
    }

    emit(CartItemAdded());
    await _persistCart();
  }

  Future<void> increaseProductQuantity(ProductEntity productEntity) async {
    final cartItem = cartEntity.getCarItem(productEntity);
    cartItem.increasquantity();
    emit(CartItemReset());
    await _persistCart();
  }

  Future<void> deleteProduct(CarItemEntity cartItem) async {
    cartEntity.removeCartItem(cartItem);
    emit(CartItemRemoved());
    await _persistCart();
  }

  Future<void> decreaseProductQuantity(ProductEntity productEntity) async {
    final cartItem = cartEntity.getCarItem(productEntity);
    if (cartItem.quantity > 1) {
      cartItem.decreasquantity();
      emit(CartItemReset());
      await _persistCart();
    } else {
      await deleteProduct(cartItem);
    }
  }

  Future<void> clearCart() async {
    if (cartEntity.cartItems.isEmpty) return;
    cartEntity.clear();
    emit(CartCleared());
    await _persistCart();
  }
}
