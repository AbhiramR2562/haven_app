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
    // Get the cart entries once and store them in a local variable
    final cartEntries = cartController.cart.entries;

// Calculate the total amount and total quantity in a single loop
    double totalAmount = 0.0;
    int totalQuantity = 0;

    for (var entry in cartEntries) {
      totalAmount +=
          entry.key.price * entry.value; // Accumulate the total amount
      totalQuantity += entry.value; // Accumulate the total quantity
    }

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
          //iterates over all the entries in the cartController.cart
          for (var entry in cartController.cart.entries)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    entry.key.imageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(entry.key.name, style: const TextStyle(fontSize: 14)),
                Text('x${entry.value}'),
                Text('\$${(entry.key.price * entry.value).toStringAsFixed(2)}'),
              ],
            ),
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
