import 'package:fruit_hub/core/helper_fun/get_currency.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entites/paypal_payment_entity/details.dart';

class Amount {
  String? total;
  String? currency;
  DetailsEntity? details;

  Amount({this.total, this.currency, this.details});

  factory Amount.fromEntity(OrderInputEntity entity) {
    return Amount(
      total: entity.calculateTotalPriceAfterDiscountAndShipping().toString(),
      currency: getCurrency(),
      details: DetailsEntity.fromEntity(entity),
    );
  }

  toJson() {}
}
