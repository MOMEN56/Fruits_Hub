import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';

abstract class OrderRepo {
  Future<Either<Failure, void>> addOrder({required OrderInputEntity order});
}
