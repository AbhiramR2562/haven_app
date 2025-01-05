import 'package:flutter/material.dart';
import 'package:haven/models/product_model.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/views/receipt_page.dart';

class DirectPurchaseDialog extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  const DirectPurchaseDialog({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = product.price * quantity;
    return AlertDialog(
      title: const Text('Purchase Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display Product Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(product.name, style: const TextStyle(fontSize: 14)),
              ),
              Text('x$quantity'),
              Text('\$${(product.price * quantity).toStringAsFixed(2)}'),
            ],
          ),
          const Divider(),
          // Display Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total: ',
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
            Navigator.of(context).pop(); // Close the dialog

// Message
            showSnackBar(context, 'Proceeding to payment...');

            // Navigate to ReceiptPage after payment
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
                  products: [product], // Passing the selected product
                  quantities: quantity,
                  totalAmount: totalAmount, // Passing the total amount
                ),
              ),
            );
          },
          child: const Text('Buy Now'),
        ),
      ],
    );
  }
}
