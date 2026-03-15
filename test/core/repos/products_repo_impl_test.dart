import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo_impl.dart';
import 'package:fruit_hub/core/services/data_service.dart';

class _FakeDatabaseService implements DatabaseService {
  dynamic response;
  String? lastPath;
  String? lastDocumentId;
  Map<String, dynamic>? lastQuery;

  _FakeDatabaseService({required this.response});

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  }) async {
    lastPath = path;
    lastDocumentId = docuementId;
    lastQuery = query;
    return response;
  }
}

void main() {
  group('ProductsRepoImpl visibility filtering', () {
    test('getProducts keeps visible products only', () async {
      final fakeDb = _FakeDatabaseService(
        response: [
          {'name': 'Apple', 'code': 'A1', 'is_visible': true},
          {'name': 'Orange', 'code': 'O1', 'is_visible': false},
          {'name': 'Banana', 'code': 'B1'},
        ],
      );
      final repo = ProductsRepoImpl(fakeDb);

      final Either<Failure, List<ProductEntity>> result = await repo.getProducts();
      final products = result.getOrElse(() => []);

      expect(fakeDb.lastPath, 'products');
      expect(fakeDb.lastQuery?['is_visible'], isTrue);
      expect(products.map((e) => e.code).toList(), ['A1', 'B1']);
    });

    test('getBestSellingProducts sends visibility query and excludes hidden', () async {
      final fakeDb = _FakeDatabaseService(
        response: [
          {'name': 'Mango', 'code': 'M1', 'is_visible': true},
          {'name': 'Kiwi', 'code': 'K1', 'is_visible': false},
        ],
      );
      final repo = ProductsRepoImpl(fakeDb);

      final result = await repo.getBestSellingProducts();
      final products = result.getOrElse(() => []);

      expect(fakeDb.lastPath, 'products');
      expect(fakeDb.lastQuery?['limit'], 10);
      expect(fakeDb.lastQuery?['orderBy'], 'selling_count');
      expect(fakeDb.lastQuery?['descending'], isTrue);
      expect(fakeDb.lastQuery?['is_visible'], isTrue);
      expect(products.map((e) => e.code).toList(), ['M1']);
    });
  });
}
