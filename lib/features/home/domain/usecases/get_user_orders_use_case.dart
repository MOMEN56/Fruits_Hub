import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';

class GetUserOrdersUseCase {
  const GetUserOrdersUseCase(this._orderRepo);

  final OrderRepo _orderRepo;

  Future<Either<Failure, List<UserOrderEntity>>> call({
    required String userId,
  }) {
    return _orderRepo.getUserOrders(userId: userId);
  }
}
