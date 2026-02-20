import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project_pwa/modules/cart/domain/entities/cart_item.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_event.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_state.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';

void main() {
  late CartBloc cartBloc;

  final productA = ProductItem(
    id: 1,
    title: "Apple",
    price: 100,
    image: '',
    category: 'Fruits',
  );
  final productB = ProductItem(
    id: 2,
    title: "Banana",
    price: 50,
    image: '',
    category: 'Fruits',
  );

  setUp(() {
    cartBloc = CartBloc();
  });

  tearDown(() {
    cartBloc.close();
  });

  /// ---------------------------------------------------------
  /// INITIAL STATE
  /// ---------------------------------------------------------
  test('initial state is empty', () {
    expect(cartBloc.state.items, isEmpty);
  });

  /// ---------------------------------------------------------
  /// ADD PRODUCT
  /// ---------------------------------------------------------
  blocTest<CartBloc, CartState>(
    'adds product to cart',
    build: () => CartBloc(),
    act: (bloc) => bloc.add(AddToCart(productA)),
    expect: () => [
      CartState(items: [CartItem(product: productA, quantity: 1)]),
    ],
  );

  /// ---------------------------------------------------------
  /// ADD SAME PRODUCT → INCREASE QUANTITY
  /// ---------------------------------------------------------
  blocTest<CartBloc, CartState>(
    'increments quantity when same product added again',
    build: () => CartBloc(),
    act: (bloc) {
      bloc.add(AddToCart(productA));
      bloc.add(AddToCart(productA));
    },
    expect: () => [
      CartState(items: [CartItem(product: productA, quantity: 1)]),
      CartState(items: [CartItem(product: productA, quantity: 2)]),
    ],
  );

  /// ---------------------------------------------------------
  /// REMOVE PRODUCT → DECREASE QUANTITY
  /// ---------------------------------------------------------
  blocTest<CartBloc, CartState>(
    'decrements quantity when removing product',
    build: () => CartBloc(),
    act: (bloc) {
      bloc.add(AddToCart(productA));
      bloc.add(AddToCart(productA));
      bloc.add(RemoveFromCart(productA));
    },
    expect: () => [
      CartState(items: [CartItem(product: productA, quantity: 1)]),
      CartState(items: [CartItem(product: productA, quantity: 2)]),
      CartState(items: [CartItem(product: productA, quantity: 1)]),
    ],
  );

  /// ---------------------------------------------------------
  /// REMOVE PRODUCT COMPLETELY
  /// ---------------------------------------------------------
  blocTest<CartBloc, CartState>(
    'removes product when quantity becomes zero',
    build: () => CartBloc(),
    act: (bloc) {
      bloc.add(AddToCart(productA));
      bloc.add(RemoveFromCart(productA));
    },
    expect: () => [
      CartState(items: [CartItem(product: productA, quantity: 1)]),
      const CartState(items: []),
    ],
  );

  /// ---------------------------------------------------------
  /// MULTIPLE PRODUCTS
  /// ---------------------------------------------------------
  blocTest<CartBloc, CartState>(
    'handles multiple products',
    build: () => CartBloc(),
    act: (bloc) {
      bloc.add(AddToCart(productA));
      bloc.add(AddToCart(productB));
    },
    expect: () => [
      CartState(items: [CartItem(product: productA, quantity: 1)]),
      CartState(
        items: [
          CartItem(product: productA, quantity: 1),
          CartItem(product: productB, quantity: 1),
        ],
      ),
    ],
  );

  /// ---------------------------------------------------------
  /// CLEAR CART
  /// ---------------------------------------------------------
  blocTest<CartBloc, CartState>(
    'clears cart',
    build: () => CartBloc(),
    act: (bloc) {
      bloc.add(AddToCart(productA));
      bloc.add(ClearCart());
    },
    expect: () => [
      CartState(items: [CartItem(product: productA, quantity: 1)]),
      const CartState(),
    ],
  );
}
