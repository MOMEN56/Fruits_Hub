import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/database_services.dart';
import 'package:fruit_hub/core/services/firestore_service.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/checkout/data/models/order_model.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';

class OrderRepoImpl implements OrderRepo {
  final DatabaseServices fireStoreService;

  OrderRepoImpl(this.fireStoreService);
  @override
  Future<Either<Failure, void>> addOrder({required OrderEntity order}) async {
    try {
      await fireStoreService.addData(
        path: BackendEndpoints.addOrder,
        data: OrderModel.fromEntity(order).toJson(),
      );
      return Right(null);
    } catch (e) {
      return Left((ServerFailure(e.toString())));
    }
  }
}
