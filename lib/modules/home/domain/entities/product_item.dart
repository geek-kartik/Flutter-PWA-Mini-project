library;

/// Simple entity representing list of products shown on the home screen.
///
/// with real fields (e.g. product cards).
class ProductItem {
  /// Unique identifier for the item.
  final int id;

  /// Display title for the item.
  final String title;

  /// Price of the product.
  final double price;

  /// Image of the product.
  final String image;

  /// Create an immutable [ProductItem] entity.
  const ProductItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'price': price, 'image': image};
  }

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      id: map['id'],
      title: map['title'] ?? 1,
      price: map['price'] ?? 1,
      image: map['image'] ?? 1,
    );
  }

  factory ProductItem.empty() {
    return ProductItem(id: 0, title: "NA", price: 0, image: "NA");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          image == other.image;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ price.hashCode ^ image.hashCode;
}
