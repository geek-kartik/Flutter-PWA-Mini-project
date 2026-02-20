import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/modules/cart/domain/entities/cart_item.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_event.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_state.dart';

/// BLoC for the cart feature.
///
/// Manages the counter value shown on the cart page and reacts
/// to [CartEvent]s by emitting new [CartState]s.

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddToCart>((event, emit) {
      final existingIndex = state.items.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      List<CartItem> updated = List.from(state.items);

      if (existingIndex >= 0) {
        final existingItem = updated[existingIndex];
        updated[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        updated.add(CartItem(product: event.product, quantity: 1));
      }

      emit(CartState(items: updated));
    });

    on<RemoveFromCart>((event, emit) {
      final existingIndex = state.items.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      List<CartItem> updated = List.from(state.items);

      if (existingIndex >= 0 && updated[existingIndex].quantity > 1) {
        final existingItem = updated[existingIndex];
        updated[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
      } else {
        updated.removeAt(existingIndex);
      }

      emit(CartState(items: updated));
    });

    on<ClearCart>((event, emit) {
      emit(const CartState());
    });
  }
}
