import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/modules/cart/domain/entities/cart_item.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/quantity_stepper.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_event.dart';

/// This is common widget represents quantity of product in cart
class CartActionWidget extends StatelessWidget {
  final ProductItem product;

  const CartActionWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final quantity = context.select<CartBloc, int>((bloc) {
      final item = bloc.state.items
          .firstWhere(
            (e) => e.product == product,
        orElse: () => CartItem.empty(),
      );
      return item.quantity;
    });

    final cartBloc = context.read<CartBloc>();

    if (quantity == 0) {
      return SizedBox(
        height: 28,
        child: OutlinedButton(
          onPressed: () {
            cartBloc.add(AddToCart(product));
          },
          child: const Text("ADD"),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuantityStepper(
          icon: Icons.remove,
          onPressed: () {
            cartBloc.add(RemoveFromCart(product));
          },
        ),
        const SizedBox(width: 6),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 6),
        QuantityStepper(
          icon: Icons.add,
          onPressed: () {
            cartBloc.add(AddToCart(product));
          },
        ),
      ],
    );
  }
}
