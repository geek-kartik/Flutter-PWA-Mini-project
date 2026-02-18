library;

import 'package:equatable/equatable.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';

/// Events for the cart feature.
///
/// These events represent user interactions
/// that can cause the cart page state to change.
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final ProductItem product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final ProductItem product;

  const RemoveFromCart(this.product);

  @override
  List<Object?> get props => [product];
}

class ClearCart extends CartEvent {}

