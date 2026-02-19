import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_bloc.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_event.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_state.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';
import 'package:mini_project_pwa/modules/home/domain/repositories/home_repository.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository repository;
  late List<ProductItem> products;

  setUp(() {
    repository = MockHomeRepository();

    products = [
      ProductItem(
        id: 1,
        title: 'iPhone',
        category: 'electronics',
        price: 1000,
        image: '',
      ),
      ProductItem(
        id: 2,
        title: 'Shoes',
        category: 'fashion',
        price: 100,
        image: '',
      ),
      ProductItem(
        id: 3,
        title: 'Macbook',
        category: 'electronics',
        price: 2000,
        image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
      ),
    ];
  });

  group('HomeBloc - LoadProducts', () {
    blocTest<HomeBloc, HomeState>(
      'emits loading then loaded when success',
      build: () {
        when(
          () => repository.loadProductItems(),
        ).thenAnswer((_) async => products);

        return HomeBloc(repository);
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        isA<ProductLoading>(),
        isA<ProductLoaded>().having((s) => s.products.length, 'length', 3),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits error when repository throws',
      build: () {
        when(() => repository.loadProductItems()).thenThrow(Exception('fail'));

        return HomeBloc(repository);
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [isA<ProductLoading>(), isA<ProductError>()],
    );
  });

  group('HomeBloc - Search', () {
    blocTest<HomeBloc, HomeState>(
      'filters by search query',
      build: () {
        final bloc = HomeBloc(repository);
        bloc.allProducts = products;
        bloc.searchTextController.text = 'iphone';
        return bloc;
      },
      act: (bloc) => bloc.add(SearchQueryChanged()),
      wait: const Duration(milliseconds: 350), // debounce
      expect: () => [
        isA<ProductLoaded>().having(
          (s) => s.products.first.title,
          'title',
          'iPhone',
        ),
      ],
    );
  });

  group('HomeBloc - Filter', () {
    blocTest<HomeBloc, HomeState>(
      'filters by category',
      build: () {
        final bloc = HomeBloc(repository);
        bloc.allProducts = products;
        return bloc;
      },
      act: (bloc) => bloc.add(FilterChanged(category: 'electronics')),
      expect: () => [
        isA<ProductLoaded>().having((s) => s.products.length, 'length', 2),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'filters by price range',
      build: () {
        final bloc = HomeBloc(repository);
        bloc.allProducts = products;
        return bloc;
      },
      act: (bloc) =>
          bloc.add(FilterChanged(priceRange: const RangeValues(0, 500))),
      expect: () => [
        isA<ProductLoaded>().having((s) => s.products.length, 'length', 1),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'combines search + category + price',
      build: () {
        final bloc = HomeBloc(repository);
        bloc.allProducts = products;
        bloc.searchTextController.text = 'mac';
        return bloc;
      },
      act: (bloc) => bloc.add(
        FilterChanged(
          category: 'electronics',
          priceRange: const RangeValues(1500, 3000),
        ),
      ),
      expect: () => [
        isA<ProductLoaded>().having(
          (s) => s.products.first.title,
          'title',
          'Macbook',
        ),
      ],
    );
  });
}
