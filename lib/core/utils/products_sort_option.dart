import 'package:fruit_hub/generated/l10n.dart';

enum ProductsSortOption {
  none,
  priceHighToLow,
  priceLowToHigh,
  bestSelling,
}

extension ProductsSortOptionExtension on ProductsSortOption {
  bool get isNotDefault => this != ProductsSortOption.none;

  String get label {
    switch (this) {
      case ProductsSortOption.none:
        return S.current.defaultSort;
      case ProductsSortOption.priceHighToLow:
        return S.current.priceHighToLow;
      case ProductsSortOption.priceLowToHigh:
        return S.current.priceLowToHigh;
      case ProductsSortOption.bestSelling:
        return S.current.bestSellingFirst;
    }
  }
}
