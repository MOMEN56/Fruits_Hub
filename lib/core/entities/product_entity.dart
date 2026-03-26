import 'review_entity.dart';

class ProductEntity {
  const ProductEntity({
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    this.sellingCount = 0,
    required this.reviews,
    required this.expirationsMonths,
    required this.numberOfCalories,
    required this.unitAmount,
    this.isOrganic = false,
    required this.isFeatured,
    this.imageUrl,
    this.isVisible = true,
  });

  final String name;
  final String code;
  final String description;
  final num price;
  final int sellingCount;
  final bool isFeatured;
  final String? imageUrl;
  final int expirationsMonths;
  final bool isOrganic;
  final int numberOfCalories;
  final num avgRating = 0;
  final num ratingCount = 0;
  final int unitAmount;
  final List<ReviewEntity> reviews;
  final bool isVisible;
}
