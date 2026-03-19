import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/checkout/data/models/order_model.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';

class OrderRepoImpl implements OrderRepo {
  OrderRepoImpl(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<Either<Failure, String>> addOrder({
    required OrderInputEntity order,
  }) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      await _databaseService.addData(
        path: BackendEndpoint.addOrder,
        data: orderModel.toJson(),
      );
      return Right(orderModel.orderId);
    } catch (e) {
      return Left((ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<UserOrderEntity>>> getUserOrders({
    required String userId,
  }) async {
    try {
      final rawData = await _databaseService.getData(
        path: BackendEndpoint.addOrder,
        query: {'u_id': userId, 'orderBy': 'created_at', 'descending': true},
      );
      final orders =
          (rawData as List)
              .whereType<Map>()
              .map(
                (e) => UserOrderEntity.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
