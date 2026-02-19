part of '../home_page.dart';

/// Search and Filter Header View
class _SearchFilterHeader extends StatefulWidget {
  const _SearchFilterHeader({super.key});

  @override
  State<_SearchFilterHeader> createState() => _SearchFilterHeaderState();
}

class _SearchFilterHeaderState extends State<_SearchFilterHeader> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();

        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: TextField(
                  controller: homeBloc.searchTextController,
                  onChanged: (value) {
                    homeBloc.add(SearchQueryChanged(value));
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    /// Invoke filter sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      constraints: BoxConstraints(minWidth: double.infinity),
                      builder: (context) {
                        return _FilterSheet(
                          categories: homeBloc.allProducts
                              .map((e) => e.category)
                              .toSet()
                              .toList(),
                          selectedCategory: homeBloc.selectedCategory,
                          selectedPriceRange: homeBloc.selectedPriceRange,
                          onApply: (category, priceRange) {
                            homeBloc.add(
                              FilterChanged(
                                category: category,
                                priceRange: priceRange,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },

                  icon: Stack(
                    children: [
                      Icon(Icons.filter_list_alt),

                      /// Indicate Filter is applied
                      if (homeBloc.selectedCategory != null ||
                          homeBloc.selectedPriceRange != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 0,
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
