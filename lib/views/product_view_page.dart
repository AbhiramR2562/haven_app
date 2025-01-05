import 'package:flutter/material.dart';
import 'package:haven/controllers/cart_controller.dart';
import 'package:haven/models/product_model.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/widget/direct_purchase_dialog_widget.dart';
import 'package:haven/widget/my_button_widget.dart';
import 'package:haven/widget/quantity_button_widget.dart';
import 'package:provider/provider.dart';

class ProductViewPage extends StatefulWidget {
  final ProductModel product;
  const ProductViewPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  // Starting quantity (default is zero)
  int _quantity = 1;

  // Methode to increase the quantity
  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Methode to decrease the quantity
  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  // Add to cart
  void _addToCart() {
    if (_quantity > 0) {
      final cartController =
          Provider.of<CartController>(context, listen: false);

      // Add the product to the cart with selected quantity
      for (int i = 0; i < _quantity; i++) {
        cartController.addToCart(widget.product);
      }

      // Show confirmation message

      showSnackBar(context, '${widget.product.name} added to cart');
    } else {
      // Show message if quantity is 0

      showSnackBar(context, 'Please select a quantity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            MyButton(
              text: "Add to cart",
              onTap: () {
                _addToCart();
              },
            ),
            MyButton(
              text: "Check Out",
              onTap: () {
                // Navigate to the CheckoutPage
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CheckoutPage(
                //       product: widget.product,
                //       quantity: _quantity,
                //     ),
                //   ),
                // );
                // Show the CheckoutDialog when proceeding to payment
                showDialog(
                    context: context,
                    builder: (context) => DirectPurchaseDialog(
                        product: widget.product, quantity: _quantity));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Image.asset(
                widget.product.imageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                QuantityButtonWidget(
                  icon: Icons.remove,
                  onTap: _decreaseQuantity,
                ),
                const SizedBox(width: 10),
                Text(
                  "$_quantity",
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(width: 10),
                QuantityButtonWidget(
                  icon: Icons.add,
                  onTap: _increaseQuantity,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.details,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
