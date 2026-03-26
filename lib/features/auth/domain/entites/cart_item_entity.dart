import 'package:fruit_hub/core/entities/product_entity.dart';

class CarItemEntity {
  final ProductEntity productEntity;
  int quantity;

  CarItemEntity({required this.productEntity, this.quantity = 0});

  num calculateTotalPrice() {
    return productEntity.price * quantity;
  }

  num calculateTotalWeight() {
    return productEntity.unitAmount * quantity;
  }

  void increasquantity() {
    quantity++;
  }

  void decreasquantity() {
    quantity--;
  }

}
