import 'package:bloc/bloc.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/helper_fun/get_dummy_product.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  int productsLength = 0;
  Future<void> getProducts() async {
    emit(ProductsLoading());
    await Future.delayed(
      const Duration(seconds: 2),
    ); // simulate loading زي السيرفر

    // dummy data محلي (5 منتجات)
    List<ProductEntity> dummyProducts =
        getDummyProducts(); // الدالة اللي عندك جاهزة

    emit(ProductsSuccess(dummyProducts));
  }

  Future<void> getBestSellingProducts() async {
    emit(ProductsLoading());
    await Future.delayed(const Duration(seconds: 2));

    List<ProductEntity> dummyBestSelling =
        getDummyProducts() // أو غيرها لو عايز تفرق
            .take(10) // أول 10
            .toList();

    productsLength = dummyBestSelling.length;
    emit(ProductsSuccess(dummyBestSelling));
  }
}
