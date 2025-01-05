import 'package:flutter/material.dart';
import 'package:haven/models/product_model.dart';

class CartController extends ChangeNotifier {
  // Store products and their quantities
  final Map<ProductModel, int> _cart = {};

  // Getter to provide access to the cart items
  Map<ProductModel, int> get cart => _cart;

  // Adds a product to the cart and notifies listeners
  void addToCart(ProductModel product) {
    if (_cart.containsKey(product)) {
      // If the product is already in the cart, increase its quantity
      _cart[product] = _cart[product]! + 1;
    } else {
      // If the product is not in the cart, add it with quantity 1
      _cart[product] = 1;
    }
    notifyListeners();
  }

  // Removes a product from the cart and notifies listeners
  void removeFromCart(ProductModel product) {
    if (_cart.containsKey(product)) {
      if (_cart[product]! > 1) {
        // If the quantity is greater than 1, decrease the quantity
        _cart[product] = _cart[product]! - 1;
      } else {
        // If the quantity is 1, remove the product from the cart
        _cart.remove(product);
      }
      notifyListeners();
    }
  }

  // Clears all items from the cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
