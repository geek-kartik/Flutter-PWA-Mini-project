library;

import 'package:equatable/equatable.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';

/// State for the home feature.
class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

/// Loading state for product list api
class ProductLoading extends HomeState {}

/// Loaded state for product list api
class ProductLoaded extends HomeState {
  final List<ProductItem> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

/// Error state for any product list api error
class ProductError extends HomeState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
