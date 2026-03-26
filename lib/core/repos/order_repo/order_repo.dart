import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entities/user_order_entity.dart';

abstract class OrderRepo {
  Future<Either<Failure, String>> addOrder({required OrderInputEntity order});
  Future<Either<Failure, List<UserOrderEntity>>> getUserOrders({
    required String userId,
  });
}
