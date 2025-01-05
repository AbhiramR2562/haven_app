import 'package:flutter/material.dart';
import 'package:haven/controllers/cart_controller.dart';
import 'package:haven/models/product_model.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/views/receipt_page.dart';

class CheckoutDialog extends StatelessWidget {
  final CartController cartController;

  CheckoutDialog({required this.cartController});

  @override
  Widget build(BuildContext context) {
    final totalAmount = cartController.cart.entries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.key.price * entry.value,
    );

    // Calculate total quantity of all items in the cart
    final totalQuantity = cartController.cart.entries.fold<int>(
      0,
      (sum, entry) => sum + entry.value,
    );

    // Generate a list of products for the receipt dialog
    final products = cartController.cart.entries.map((entry) {
      // Creating ProductModel instances for each cart item
      return ProductModel(
        id: entry.key.id,
        name: entry.key.name,
        description: entry.key.description,
        category: entry.key.category,
        details: entry.key.details,
        price: entry.key.price,
        imageUrl: entry.key.imageUrl,
      );
    }).toList();

    return AlertDialog(
      title: const Text('Cart Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display Cart Details
          ...cartController.cart.entries.map((entry) {
            final product = entry.key;
            final quantity = entry.value;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    product.imageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(product.name, style: const TextStyle(fontSize: 14)),
                Text('x$quantity'),
                Text('\$${(product.price * quantity).toStringAsFixed(2)}'),
              ],
            );
          }).toList(),
          const Divider(),
          // Display Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        // Payment Button
        ElevatedButton(
          onPressed: () {
            // Clear the cart after payment process
            cartController.clearCart();

            Navigator.of(context).pop(); // Close the dialog

            showSnackBar(context, "Proceeding to payment...");

            // Show the payment receipt dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReceiptPage(
                        products: products,
                        totalAmount: totalAmount,
                        quantities: totalQuantity,
                      )),
            );
          },
          child: const Text('Buy Now'),
        ),
      ],
    );
  }
}
