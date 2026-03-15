import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub/core/models/product_model.dart';

void main() {
  group('ProductModel visibility', () {
    test('shows product when is_visible is true', () {
      final entity = ProductModel.fromJson({
        'name': 'Apple',
        'code': 'A1',
        'is_visible': true,
      }).toEntity();

      expect(entity.isVisible, isTrue);
    });

    test('hides product when is_visible is false', () {
      final entity = ProductModel.fromJson({
        'name': 'Orange',
        'code': 'O1',
        'is_visible': false,
      }).toEntity();

      expect(entity.isVisible, isFalse);
    });

    test('defaults to visible when is_visible is missing', () {
      final entity = ProductModel.fromJson({
        'name': 'Banana',
        'code': 'B1',
      }).toEntity();

      expect(entity.isVisible, isTrue);
    });
  });
}
