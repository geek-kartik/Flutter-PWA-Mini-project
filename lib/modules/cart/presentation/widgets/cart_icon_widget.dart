import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/config/app_navigator.dart';
import 'package:mini_project_pwa/config/constants/route_constants.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_state.dart';

/// Widget for cart badge
class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                AppNavigator.go(context, RouteConstants.cart);
              },
            ),
            if (state.totalItems > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    state.totalItems.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
