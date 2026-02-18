library;

import 'package:equatable/equatable.dart';
import 'package:mini_project_pwa/modules/cart/domain/entities/cart_item.dart';

/// State for the cart feature.

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
