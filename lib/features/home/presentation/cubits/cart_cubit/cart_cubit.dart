import 'package:bloc/bloc.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:fruit_hub/features/home/domain/repos/cart_repository.dart';
import 'package:flutter/foundation.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required CartRepository cartRepository})
    : _cartRepository = cartRepository,
      super(CartInitial()) {
    _hydrateCartFromStorage();
  }

  final CartRepository _cartRepository;
  CartEntity cartEntity = CartEntity([]);

  Future<void> _hydrateCartFromStorage() async {
    cartEntity = await _cartRepository.loadCart();
    emit(CartHydrated());
  }

  Future<void> addProduct(
    ProductEntity productEntity, {
    int quantity = 1,
  }) async {
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
    await _cartRepository.clearCart();
  }

  Future<void> _persistCart() async {
    await _cartRepository.saveCart(cartEntity);
  }
}
