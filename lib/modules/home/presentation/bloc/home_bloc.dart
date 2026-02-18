library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/modules/home/domain/repositories/home_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

/// BLoC for the home feature.
///
/// Manages the counter value shown on the home page and reacts
/// to [HomeEvent]s by emitting new [HomeState]s.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Create a [HomeBloc] with an initial counter value of zero.
  final HomeRepository repository;

  HomeBloc(this.repository) : super(ProductLoading()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.loadProductItems();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}

