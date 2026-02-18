library;

import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';

/// Simple entity representing added quantity of each product in cart.
class CartItem {
  /// details of product.
  final ProductItem product;

  /// quantity of each product added in cart.
  final int quantity;

  /// Create an immutable [CartItem] entity.
  const CartItem({required this.product, required this.quantity});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          quantity == other.quantity;

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }

  factory CartItem.empty() {
    return CartItem(
      product: ProductItem(id: 0, title: "NA", price: 0, image: "NA"),
      quantity: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductItem.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
    );
  }
}
