library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/core/utils/helpers/bloc_transform_helper.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';
import 'package:mini_project_pwa/modules/home/domain/repositories/home_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

/// BLoC for the home feature.
///
/// Manages the counter value shown on the home page and reacts
/// to [HomeEvent]s by emitting new [HomeState]s.

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  List<ProductItem> allProducts = [];
  String? selectedCategory;
  RangeValues? selectedPriceRange;
  final TextEditingController searchTextController = TextEditingController();

  HomeBloc(this.repository) : super(HomeState()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 300)),
    );
    on<FilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<HomeState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final products = await repository.loadProductItems();
      allProducts = products;
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<HomeState> emit) {
    emit(ProductLoaded(applySearchFilter()));
  }

  void _onFilterChanged(FilterChanged event, Emitter<HomeState> emit) {
    selectedCategory = event.category;
    selectedPriceRange = event.priceRange;

    emit(ProductLoaded(applySearchFilter()));
  }

  /// Combine product search and filter results
  List<ProductItem> applySearchFilter() {
    /// Get product search results
    final searchQuery = searchTextController.text.toLowerCase();

    return allProducts.where((product) {
      /// Filter for product name
      final matchesName =
          searchQuery.isEmpty ||
          product.title.toLowerCase().contains(searchQuery);

      /// Filter for product category
      final matchesCategory =
          selectedCategory == null || product.category == selectedCategory;

      /// Filter for product price
      final matchesPrice =
          selectedPriceRange == null ||
          (product.price >= selectedPriceRange!.start &&
              product.price <= selectedPriceRange!.end);

      return matchesName && matchesCategory && matchesPrice;
    }).toList();
  }

  @override
  Future<void> close() {
    searchTextController.dispose();
    return super.close();
  }
}
