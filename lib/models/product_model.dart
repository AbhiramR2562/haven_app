class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String details;
  final double price;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.details,
    required this.price,
    required this.imageUrl,
  });

  // Adding the copyWith method
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? details,
    double? price,
    String? imageUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      details: details ?? this.details,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
