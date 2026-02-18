import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/core/widgets/common_app_bar.dart';
import 'package:mini_project_pwa/core/widgets/optimized_image.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/cart_action_widget.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/cart_icon_widget.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_bloc.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_state.dart';

/// Home page that displays a simple counter using [HomeBloc].
///
/// This widget is part of the presentation layer and demonstrates
/// how to connect a BLoC to a screen without any data layer calls.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Flutter PWA",
        centerTitle: true,
        actions: [CartIconWidget(), SizedBox(width: 8)],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;

                double width = constraints.maxWidth;

                if (width < 600) {
                  // Mobile
                  crossAxisCount = 2;
                } else if (width < 800) {
                  // Tablet mini
                  crossAxisCount = 3;
                } else if (width < 1000) {
                  // Tablet max
                  crossAxisCount = 4;
                } else {
                  // Desktop
                  crossAxisCount = 5;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];

                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Expanded(
                              child: OptimizedImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "\$${product.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                CartActionWidget(product: product),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
