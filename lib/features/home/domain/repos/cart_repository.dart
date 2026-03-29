import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> loadCart();
  Future<void> saveCart(CartEntity cartEntity);
  Future<void> clearCart();
}
