import 'package:flutter/material.dart';
import 'package:haven/controllers/cart_controller.dart';
import 'package:haven/controllers/product_controller.dart';
import 'package:haven/models/product_model.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/widget/my_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCardDialogBox extends StatefulWidget {
  const ScratchCardDialogBox({super.key});

  @override
  State<ScratchCardDialogBox> createState() => _ScratchCardDialogBoxState();
}

class _ScratchCardDialogBoxState extends State<ScratchCardDialogBox> {
  final scratchKey = GlobalKey<ScratcherState>();

  // Track the card is fully revealed
  bool _isRevealed = false;

  // ProductController
  final ProductController _productController = ProductController();

  // Get a random product from the controller
  late ProductModel randomProduct;

  @override
  void initState() {
    super.initState();

    // Fetch a random product at the start
    randomProduct = _productController.getRandomProduct();

    // Set the product price to Zero
    randomProduct = randomProduct.copyWith(price: 0);
  }

  // Reveal the scratch card
  void _revealScratchCard() {
    scratchKey.currentState!
        .reveal(duration: const Duration(milliseconds: 500));
    setState(() {
      _isRevealed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _isRevealed
          ? const Text("Wow, congrats!")
          : const Text("A Haven Surprise!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scratch card
          Scratcher(
              key: scratchKey,

              // color: Colors.green,
              image: const Image(
                image: AssetImage("assets/images/scratch_card_image.jpg"),
              ),
              brushSize: 30,
              accuracy: ScratchAccuracy.low,
              threshold: 70,
              onThreshold: () {
                print("threshhold reached ");
                _revealScratchCard();
              },
              child: SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: _isRevealed
                      ? Image.asset(randomProduct.imageUrl)
                      : const Text(
                          "Scratch to Reveal",
                        ),
                ),
              )),
          _isRevealed
              ? Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      randomProduct.name, // Show product name
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${randomProduct.price.toStringAsFixed(2)}", // Show product price
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "You got a wonderful plant as a first gift!", // Congratulatory message
                      style: TextStyle(fontSize: 14, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    MyButton(
                      text: "Add to cart",
                      onTap: () {
                        // Add the product to the cart using CartController
                        final cartController =
                            Provider.of<CartController>(context, listen: false);
                        cartController.addToCart(randomProduct);

                        // Optionally, show a confirmation message to the user

                        showSnackBar(context,
                            "${randomProduct.name} has been added to your cart.");

                        // Close the dialog after adding the item to the cart
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Text("Wow, you got a Gift!"),
                      SizedBox(height: 13),
                      Text(
                        "Scratch to Reveal",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
