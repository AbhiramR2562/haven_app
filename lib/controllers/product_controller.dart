import 'dart:math';

import 'package:haven/models/product_model.dart';
import 'package:haven/repositories/product_repositories.dart';

class ProductController {
  final ProductRepositories _repository = ProductRepositories();

  // Fetch products from the repository
  List<ProductModel> getProducts() {
    return _repository.fetchProducts();
  }

  // Fetch a random product by its ID
  ProductModel getRandomProduct() {
    // Extract all product IDs
    List<String> productIds =
        _repository.fetchProducts().map((product) => product.id).toList();

    // Create a random generator
    Random random = Random();

    // Pick a random ID from the List of the products IDs
    String randomId = productIds[random.nextInt(productIds.length)];

    // Find the product with the selected ID
    return _repository
        .fetchProducts()
        .firstWhere((product) => product.id == randomId);
  }
}
