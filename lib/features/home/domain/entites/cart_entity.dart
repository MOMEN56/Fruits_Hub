import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';

class CartEntity {
  final List<CarItemEntity> cartItems;

  CartEntity(this.cartItems);

  addCartItem(CarItemEntity cartItemEntity) {
    cartItems.add(cartItemEntity);
  }

  removeCartItem(CarItemEntity carItem) {
    cartItems.remove(carItem);
  }

  clear() {
    cartItems.clear();
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var carItem in cartItems) {
      totalPrice += carItem.calculateTotalPrice();
    }
    return totalPrice;
  }

  bool isExis(ProductEntity product) {
    for (var carItem in cartItems) {
      if (carItem.productEntity.code == product.code) {
        return true;
      }
    }
    return false;
  }

  CarItemEntity getCarItem(ProductEntity product) {
    for (var carItem in cartItems) {
      if (carItem.productEntity.code == product.code) {
        return carItem;
      }
    }
    return CarItemEntity(productEntity: product, quantity: 1);
  }
}
