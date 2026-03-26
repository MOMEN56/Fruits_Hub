import 'dart:io';

import 'package:fruit_hub/core/entities/product_entity.dart';

import 'review_model.dart';

class ProductModel {
  ProductModel({
    this.name,
    this.code,
    this.description,
    this.expirationsMonths,
    this.numberOfCalories,
    this.unitAmount,
    this.reviews,
    this.price,
    this.sellingCount = 0,
    this.isOrganic,
    this.image,
    this.isFeatured,
    this.imageUrl,
    this.isVisible,
  });

  final String? name;
  final String? code;
  final String? description;
  final num? price;
  final File? image;
  final bool? isFeatured;
  final bool? isVisible;
  String? imageUrl;
  final int? expirationsMonths;
  final bool? isOrganic;
  final int? numberOfCalories;
  final num avgRating = 0;
  final num ratingCount = 0;
  final int? unitAmount;
  final int? sellingCount;
  final List<ReviewModel>? reviews;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      price: json['price'] as num?,
      isFeatured: json['is_featured'] as bool?,
      isVisible: json['is_visible'] as bool? ?? true,
      imageUrl: json['image_url'] as String?,
      expirationsMonths:
          json['expirations_months'] as int? ?? 0, // null-safe ?? 0
      isOrganic: json['is_organic'] as bool? ?? false,
      numberOfCalories: json['number_of_calories'] as int? ?? 0,
      unitAmount: json['unit_amount'] as int? ?? 0,
      sellingCount: json['selling_count'] as int? ?? 0,
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // safe empty
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      name: name ?? '',
      code: code ?? '',
      description: description ?? '',
      price: price ?? 0,
      sellingCount: sellingCount ?? 0,
      reviews: reviews?.map((e) => e.toEntity()).toList() ?? [], // null-safe
      expirationsMonths: expirationsMonths ?? 0,
      numberOfCalories: numberOfCalories ?? 0,
      unitAmount: unitAmount ?? 0,
      isOrganic: isOrganic ?? false,
      isFeatured: isFeatured ?? false,
      imageUrl: imageUrl,
      isVisible: isVisible ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'price': price,
      'selling_count': sellingCount,
      'is_featured': isFeatured,
      'is_visible': isVisible,
      'image_url': imageUrl,
      'expirations_months': expirationsMonths,
      'number_of_calories': numberOfCalories,
      'unit_amount': unitAmount,
      'is_organic': isOrganic,
      'reviews': reviews?.map((e) => e.toJson()).toList() ?? [], // null-safe
    };
  }
}
