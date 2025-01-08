import 'package:flutter/material.dart';
import 'package:haven/controllers/cart_controller.dart';
import 'package:haven/services/auth_service.dart';
import 'package:haven/services/user_sharedpreference.dart';
import 'package:haven/utils/app_theme.dart';
import 'package:haven/views/login_page.dart';
import 'package:haven/widget/bottom_nav_bar_widget.dart';
import 'package:haven/views/cart_page.dart';
import 'package:haven/views/shop_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bottomBar index controller
  int _selectedIndex = 0;

// user name
  String? userName;

  // SharedPreferencesService to fetch user data
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  // Retrieve user data (name) from SharedPreferences
  Future<void> _getUserName() async {
    final userData = await _sharedPreferencesService.getUserDetails();
    setState(() {
      userName = userData['name']; // Retrieve and store the name
    });
  }

  // Update selected index
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Page to display
  final List<Widget> _pages = [
    // Shop page
    ShopPage(),

    // Cart Page
    const CartPage(),
  ];

  // Logout
  void logOut(BuildContext context) async {
    final authService = AuthService();
    final sharedPreferencesService = SharedPreferencesService();

    try {
      await authService.signOut();

      // Clear the user data from shared preferences
      await sharedPreferencesService
          .clearUserData(); // Clear the stored user details

      // Navigate to LoginPage explicitly after signing out
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Consumer<CartController>(builder: (context, cartController, child) {
        // Get the number of the items in the cart
        int cartItemCount = cartController.cart.length;
        return MyBottomNavBar(
          onTabChange: (index) => navigateBottomBar(index),
          cartItemCount: cartItemCount,
        );
      }),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Column(
              children: [
                DrawerHeader(
                  child: Image.asset(
                    'assets/images/peace_lilly2.jpg',
                    // color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            GestureDetector(
              onTap: () {
                logOut(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 25.0, bottom: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome to HAVEN",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  userName ?? "Guest", // Replace with dynamic user name
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            // Profile image (leading)
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'assets/images/avatarprofile2.png'), // Replace with profile image path
            ),
          ],
        ),
        centerTitle: true, // Center the title for better alignment
        backgroundColor: AppTheme.primaryColor, // AppBar background color
      ),
      body: Column(
        children: [
          // Main content area (Shop or Cart page)
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
