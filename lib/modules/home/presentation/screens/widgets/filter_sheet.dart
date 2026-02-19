part of '../home_page.dart';

/// Product filters based on category and price
class _FilterSheet extends StatefulWidget {
  final List<String> categories;
  final void Function(String? category, RangeValues? priceRange) onApply;
  final String? selectedCategory;
  final RangeValues? selectedPriceRange;

  const _FilterSheet({
    super.key,
    required this.categories,
    required this.onApply,
    required this.selectedPriceRange,
    required this.selectedCategory,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  int filterIndex = 0;
  String? _selectedCategory;
  RangeValues _priceRange = RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();

    /// Assign selected values
    _selectedCategory = widget.selectedCategory;
    if (widget.selectedPriceRange != null) {
      _priceRange = widget.selectedPriceRange!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: context.height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          /// Drag Handle
          Container(
            height: 5,
            width: 50,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),

          /// Sheet Title and Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _selectedCategory = null;
                  _priceRange = RangeValues(0, 1000);
                  widget.onApply(_selectedCategory, null);
                  if (context.mounted) AppNavigator.pop(context);
                },
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Row(
              children: [
                /// LEFT MENU - Filter tiles
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.applyOpacity(0.75),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem("Category", 0),
                      _buildMenuItem("Price", 1),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                /// RIGHT CONTENT - Category and Filter
                Expanded(
                  child: IndexedStack(
                    index: filterIndex,
                    children: [_buildCategoryView(), _buildPriceView()],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          /// Apply Button
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  /// Receive callback on apply filters
                  widget.onApply(_selectedCategory, _priceRange);
                  if (context.mounted) AppNavigator.pop(context);
                },
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, int index) {
    final isSelected = filterIndex == index;

    return InkWell(
      onTap: () => setState(() => filterIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.applyOpacity(0.75)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryView() {
    /// Single select for product category
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (_, index) {
        final category = widget.categories[index];
        final isSelected = category == _selectedCategory;

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tileColor: isSelected
              ? Colors.green.applyOpacity(0.75)
              : Colors.transparent,
          title: Text(category.capitalize),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () {
            setState(() {
              _selectedCategory = isSelected ? null : category;
            });
          },
        );
      },
    );
  }

  Widget _buildPriceView() {
    /// Range slider for product price
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Price Range", style: Theme.of(context).textTheme.titleMedium),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: AppColors.primaryBlue,
          labels: RangeLabels(
            "\$${_priceRange.start.round()}",
            "\$${_priceRange.end.round()}",
          ),
          onChanged: (values) {
            setState(() => _priceRange = values);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("\$${_priceRange.start.round()}"),
            Text("\$${_priceRange.end.round()}"),
          ],
        ),
      ],
    );
  }
}
