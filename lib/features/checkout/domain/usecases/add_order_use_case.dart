import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/features/checkout/data/services/order_creation_notifications_service.dart';
import 'package:fruit_hub/features/checkout/domain/entities/order_entity.dart';

class AddOrderUseCase {
  const AddOrderUseCase(this._orderRepo, this._notificationsService);

  final OrderRepo _orderRepo;
  final OrderCreationNotificationsService _notificationsService;

  Future<Either<Failure, String>> call({
    required OrderInputEntity order,
  }) async {
    final result = await _orderRepo.addOrder(order: order);
    await result.fold((_) async {}, (orderId) async {
      await _notificationsService.notifyOrderCreated(
        userId: order.userId,
        orderId: orderId,
      );
    });
    return result;
  }
}
