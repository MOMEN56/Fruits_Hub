import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  int productsLength = 0;

  Future<void> getProducts() async {
    emit(ProductsLoading());
    try {
      final result =
          await productsRepo
              .getProducts(); // call repo method (real from Supabase)
      result.fold(
        (failure) {
          log('Get products failure: ${failure.message}');
          emit(ProductsFailure(errMessage: failure.message));
        },
        (products) {
          log('Get products success: ${products.length}');
          emit(ProductsSuccess(products));
        },
      );
    } catch (e) {
      log('Get products error: $e');
      emit(ProductsFailure(errMessage: e.toString()));
    }
  }

  Future<void> getBestSellingProducts() async {
    emit(ProductsLoading());
    try {
      final result =
          await productsRepo.getBestSellingProducts(); // real from Supabase
      result.fold(
        (failure) {
          log('Get best selling failure: ${failure.message}');
          emit(ProductsFailure(errMessage: failure.message));
        },
        (products) {
          productsLength = products.length;
          log('Get best selling success: ${products.length}');
          emit(ProductsSuccess(products));
        },
      );
    } catch (e) {
      log('Get best selling error: $e');
      emit(ProductsFailure(errMessage: e.toString()));
    }
  }
}
