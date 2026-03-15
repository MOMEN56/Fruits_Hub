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
        return 'الترتيب الافتراضي';
      case ProductsSortOption.priceHighToLow:
        return 'السعر من الأعلى إلى الأقل';
      case ProductsSortOption.priceLowToHigh:
        return 'السعر من الأقل إلى الأعلى';
      case ProductsSortOption.bestSelling:
        return 'الأكثر مبيعًا إلى الأقل';
    }
  }
}
