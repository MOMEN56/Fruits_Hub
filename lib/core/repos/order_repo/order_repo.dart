import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';

abstract class OrderRepo {
  Future<Either<Failure, String>> addOrder({required OrderInputEntity order});
  Future<Either<Failure, List<UserOrderEntity>>> getUserOrders({
    required String userId,
  });
}
