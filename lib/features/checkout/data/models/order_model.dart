import 'package:fruit_hub/features/checkout/data/models/order_product_model.dart';
import 'package:fruit_hub/features/checkout/data/models/shipping_Address_model.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:uuid/uuid.dart';

class OrderModel {
  final double totalPrice;
  final String uId;
  final ShippingAddressModel shippingAddressModel;
  final List<OrderProductModel> orderProducts;
  final String paymentMethod;
  final String orderId;
  OrderModel({
    required this.totalPrice,
    required this.uId,
    required this.orderId,
    required this.shippingAddressModel,
    required this.orderProducts,
    required this.paymentMethod,
  });

  factory OrderModel.fromEntity(OrderInputEntity orderEntity) {
    return OrderModel(
      orderId: const Uuid().v4(),
      totalPrice: orderEntity.cartEntity.calculateTotalPrice(),
      uId: orderEntity.uID,
      shippingAddressModel: ShippingAddressModel.fromEntity(
        orderEntity.shippingAddressEntity,
      ),
      orderProducts:
          orderEntity.cartEntity.cartItems
              .map((e) => OrderProductModel.fromEntity(cartItemEntity: e))
              .toList(),
      paymentMethod: orderEntity.payWithCash! ? 'Cash' : 'Paymob',
    );
  }
  toJson() => {
    'order_id': orderId,
    'total_price': totalPrice,
    'u_id': uId,
    'status': 'pending',
    'created_at': DateTime.now().toIso8601String(),
    'shipping_address': shippingAddressModel.toJson(),
    'order_products': orderProducts.map((e) => e.toJson()).toList(),
    'payment_method': paymentMethod,
  };
}

// payment method
