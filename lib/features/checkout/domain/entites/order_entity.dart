import 'package:equatable/equatable.dart';
import 'package:fruit_hub/features/checkout/domain/entites/shipping_address_entity.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrderInputEntity extends Equatable {
  final String userId;
  final CartEntity cartEntity;
  final bool? payWithCash;
  final ShippingAddressEntity shippingAddressEntity;

  const OrderInputEntity(
    this.cartEntity, {
    this.payWithCash,
    required this.shippingAddressEntity,
    required this.userId,
  });

  OrderInputEntity copyWith({
    String? userId,
    CartEntity? cartEntity,
    bool? payWithCash,
    bool clearPaymentMethod = false,
    ShippingAddressEntity? shippingAddressEntity,
  }) {
    return OrderInputEntity(
      cartEntity ?? this.cartEntity,
      userId: userId ?? this.userId,
      payWithCash:
          clearPaymentMethod ? null : (payWithCash ?? this.payWithCash),
      shippingAddressEntity:
          shippingAddressEntity ?? this.shippingAddressEntity,
    );
  }

  bool get hasSelectedPaymentMethod => payWithCash != null;

  bool get isCashPayment => payWithCash == true;

  String get nextActionLabel {
    return isCashPayment ? S.current.confirmOrder : S.current.payment;
  }

  double get subTotalPrice => cartEntity.calculateTotalPrice();

  double get totalPrice => calculateTotalPriceAfterDiscountAndShipping();

  double get shippingCost => calculateShippingCost();

  double get shippingDiscount => calcualteShippingDiscount();

  double calculateShippingCost() {
    return isCashPayment ? 30 : 0;
  }

  double calcualteShippingDiscount() {
    return 0;
  }

  double calculateTotalPriceAfterDiscountAndShipping() {
    return cartEntity.calculateTotalPrice() +
        calculateShippingCost() -
        calcualteShippingDiscount();
  }

  @override
  String toString() {
    return 'OrderEntity{userId: $userId, cartEntity: $cartEntity, payWithCash: $payWithCash, shippingAddressEntity: $shippingAddressEntity}';
  }

  @override
  List<Object?> get props => [
    userId,
    cartEntity,
    payWithCash,
    shippingAddressEntity,
  ];
}
