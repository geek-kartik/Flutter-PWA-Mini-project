library;

import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';

/// Data model for product items used in the data layer.
///
/// Responsible for serialization and mapping to/from the [ProductItem] entity.
class ProductItemModel {
  /// Unique identifier for the item.
  final int id;

  /// Display title for the item.
  final String title;

  final double price;

  final String image;

  /// Create a [ProductItemModel].
  const ProductItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  /// Create model from JSON map.
  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'],
      image: json['image']
    );
  }

  /// Convert this model to the domain [ProductItem] entity.
  ProductItem toEntity() {
    return ProductItem(
      id: id,
      title: title,
      price: price,
      image: image,
    );
  }

  /// Create from domain [ProductItem] entity.
  factory ProductItemModel.fromEntity(ProductItem entity) {
    return ProductItemModel(
      id: entity.id,
      title: entity.title,
      price: entity.price,
      image: entity.image,
    );
  }
}

