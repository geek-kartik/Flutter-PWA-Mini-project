library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';

/// Events for the home feature.
///
/// These events represent user interactions or lifecycle triggers
/// that can cause the home screen state to change.
abstract class HomeEvent {
  const HomeEvent();
}

/// Event dispatched when the counter should be incremented.
class HomeCounterIncrementRequested extends HomeEvent {
  const HomeCounterIncrementRequested();
}

/// Event dispatched when user lands on home page.
class LoadProducts extends HomeEvent {
  const LoadProducts();
}

class SearchQueryChanged extends HomeEvent {
  const SearchQueryChanged();
}

class FilterChanged extends HomeEvent {
  final String? category;
  final RangeValues? priceRange;

  FilterChanged({this.category, this.priceRange});
}
