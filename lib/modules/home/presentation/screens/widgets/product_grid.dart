part of '../home_page.dart';

class _ProductGrid extends StatefulWidget {
  const _ProductGrid({super.key});

  @override
  State<_ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<_ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (blocContext, state) {
        if (state is ProductLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return Expanded(
              child: const Center(child: Text("No products found")),
            );
          }

          return LayoutBuilder(
            builder: (layoutContext, constraints) {
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
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
                              Text(
                                "\$${product.price}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
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

        return const SizedBox.shrink();
      },
    );
  }
}
