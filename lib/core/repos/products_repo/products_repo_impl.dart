import 'package:dartz/dartz.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/models/product_model.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/services/database_services.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';

class ProductsRepoImpl extends ProductsRepo {
  final DatabaseServices databaseServices;

  ProductsRepoImpl(this.databaseServices);
  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      var data =
          await databaseServices.getUserData(path: BackendEndpoints.getProducts)
              as List<Map<String, dynamic>>;
      List<ProductEntity> products =
          data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
      return right(products);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getbestSellingProducts() async {
    try {
      var data =
          await databaseServices.getUserData(
                path: BackendEndpoints.getProducts,
                query: {
                  "limit": 10,
                  "orderBy": "sellingCount",
                  "descending": true,
                },
              )
              as List<Map<String, dynamic>>;
      List<ProductEntity> products =
          data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
      return right(products);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
