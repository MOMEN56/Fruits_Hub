import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/models/product_model.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';

class ProductsRepoImpl extends ProductsRepo {
  final DatabaseService databaseServices;

  ProductsRepoImpl(this.databaseServices);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      var rawData = await databaseServices.getData(
        // ✔️ instance call
        path: BackendEndpoint.getProducts,
      );
      print('Raw data: $rawData'); // in try
      List<ProductEntity> products =
          (rawData as List)
              .map((e) => ProductModel.fromJson(e).toEntity())
              .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts() async {
    try {
      var data = await databaseServices.getData(
        path: BackendEndpoint.getProducts,
        query: {
          "limit": 10,
          "orderBy": "selling_count",
          "descending": true,
        }, // snake_case
      );
      List<ProductEntity> products =
          (data as List)
              .map((e) => ProductModel.fromJson(e).toEntity())
              .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
