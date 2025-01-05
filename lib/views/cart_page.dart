import 'package:flutter/material.dart';
import 'package:haven/controllers/cart_controller.dart';
import 'package:haven/models/product_model.dart';
import 'package:haven/widget/show_checkout_dialog_widget.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Total price
  double _totalPrice(Map<ProductModel, int> cartItems) {
    double total = 0.0;
    cartItems.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      // Listen to CartController
      builder: (context, cartController, child) {
        final cartItems = cartController.cart;

        if (cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty.",
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        // Calculate the total price of the items in the cart
        double totalPrice = _totalPrice(cartItems);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems.keys.toList()[index];
                  final quantity = cartItems[product]!;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    leading: Image.asset(
                      product.imageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text(
                      "\$${product.price.toStringAsFixed(2)} x $quantity", // Display quantity
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        // Remove from cart
                        cartController.removeFromCart(product);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Checkout action here
                      // For now, just print to console
                      print('Proceed to checkout');
                      showDialog(
                        context: context,
                        builder: (context) => CheckoutDialog(
                          cartController: cartController,
                        ),
                      );

                      // Navigate to the CheckoutPage
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const CheckoutPage(),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    "\$${totalPrice.toStringAsFixed(2)}", // Display total price
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
