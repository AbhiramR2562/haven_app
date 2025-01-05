import 'package:flutter/material.dart';
import 'package:haven/controllers/cart_controller.dart';
import 'package:haven/controllers/product_controller.dart';
import 'package:haven/services/user_sharedpreference.dart';
import 'package:haven/utils/animation_page_route.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/views/product_view_page.dart';
import 'package:haven/widget/product_tile_widget.dart';
import 'package:haven/widget/scratch_card_dialog_widget.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ProductController _controller = ProductController();

  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  bool _isNewUser = false;

  @override
  void initState() {
    super.initState();
    _checkNewUser();
  }

  // Check if the user is new and has not seen the scratch card
  Future<void> _checkNewUser() async {
    bool isNewUser = await _sharedPreferencesService.isNewUser();

    if (isNewUser) {
      showDialog(
          context: context,
          builder: (context) =>
              ScratchCardDialogBox()); // Show scratch card dialog
      await _sharedPreferencesService
          .setNewUser(false); // Reset the flag after showing the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch products from the controller
    final products = _controller.getProducts();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16.0, // Space between columns
          mainAxisSpacing: 16.0, // Space between rows
          childAspectRatio: 0.85, // Aspect ratio of tiles
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                AnimationPageRoute(
                  page: ProductViewPage(
                      product:
                          products[index]), // Pass the product to the next page
                ),
              );
            },
            child: ProductTile(
              product: products[index],
              onTap: () {
                // // Access CartController
                final cartController =
                    Provider.of<CartController>(context, listen: false);

                // Add the tapped product to the cart
                cartController.addToCart(products[index]);

                // Show confirmation message that the product has been added to the cart

                showSnackBar(context, '${products[index].name} added to cart');
              },
            ),
          );
        },
      ),
    );
  }
}
