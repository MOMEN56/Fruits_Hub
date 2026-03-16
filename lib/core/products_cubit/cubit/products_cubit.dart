import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/utils/products_sort_option.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  int productsLength = 0;
  List<ProductEntity> _allProducts = [];
  String _searchQuery = '';
  ProductsSortOption _selectedSortOption = ProductsSortOption.none;
  bool _hasLoadedProducts = false;

  ProductsSortOption get selectedSortOption => _selectedSortOption;
  String get searchQuery => _searchQuery;
  bool get hasUsableCache => _hasLoadedProducts;

  Future<void> getProducts() async {
    emit(ProductsLoading());
    try {
      final result =
          await productsRepo
              .getProducts(); // call repo method (real from Supabase)
      result.fold(
        (failure) {
          log('Get products failure: ${failure.message}');
          _allProducts = [];
          productsLength = 0;
          emit(ProductsFailure(errMessage: failure.message));
        },
        (products) {
          log('Get products success: ${products.length}');
          _hasLoadedProducts = true;
          _allProducts = products;
          _emitVisibleProducts();
        },
      );
    } catch (e) {
      log('Get products error: $e');
      _allProducts = [];
      productsLength = 0;
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
          _allProducts = [];
          productsLength = 0;
          emit(ProductsFailure(errMessage: failure.message));
        },
        (products) {
          log('Get best selling success: ${products.length}');
          _hasLoadedProducts = true;
          _allProducts = products;
          _emitVisibleProducts();
        },
      );
    } catch (e) {
      log('Get best selling error: $e');
      _allProducts = [];
      productsLength = 0;
      emit(ProductsFailure(errMessage: e.toString()));
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.trim();
    if (_allProducts.isEmpty && state is! ProductsSuccess) {
      return;
    }
    _emitVisibleProducts();
  }

  void updateSortOption(ProductsSortOption option) {
    _selectedSortOption = option;
    if (_allProducts.isEmpty && state is! ProductsSuccess) {
      return;
    }
    _emitVisibleProducts();
  }

  void _emitVisibleProducts() {
    final normalizedQuery = _searchQuery.toLowerCase();
    final visibleProducts =
        _allProducts
            .where(
              (product) =>
                  normalizedQuery.isEmpty ||
                  product.name.toLowerCase().contains(normalizedQuery),
            )
            .toList();

    switch (_selectedSortOption) {
      case ProductsSortOption.none:
        break;
      case ProductsSortOption.priceHighToLow:
        visibleProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductsSortOption.priceLowToHigh:
        visibleProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductsSortOption.bestSelling:
        visibleProducts.sort(
          (a, b) => b.sellingCount.compareTo(a.sellingCount),
        );
        break;
    }

    productsLength = visibleProducts.length;
    emit(ProductsSuccess(visibleProducts));
  }
}
