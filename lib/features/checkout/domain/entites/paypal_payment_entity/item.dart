import 'package:fruit_hub/core/helper_fun/get_currency.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';

class ItemEntity {
  String? name;
  int? quantity;
  String? price;
  String? currency;

  ItemEntity({this.name, this.quantity, this.price, this.currency});

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
    'currency': currency,
  };

  factory ItemEntity.fromEntity(CarItemEntity itemEntity) {
    return ItemEntity(
      name: itemEntity.productEntity.name,
      quantity: itemEntity.quantity,
      price: itemEntity.productEntity.price.toString(),
      currency: getCurrency(),
    );
  }
}
