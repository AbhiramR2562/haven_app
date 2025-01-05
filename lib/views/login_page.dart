import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:haven/services/auth_service.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/views/home_page.dart';
import 'package:haven/widget/my_button_widget.dart';
import 'package:haven/widget/my_textfield_widget.dart';
import 'package:haven/views/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Email and Password (pw) Controllers
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  bool _isLoading = false;

  // Login Method
  void login(BuildContext context) async {
    // Validate input fields
    if (_emailController.text.trim().isEmpty ||
        _pwController.text.trim().isEmpty) {
      showSnackBar(context, 'Please enter both email and password.');
      return;
    }

    // Auth service instance
    final authService = AuthService();

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt login
      await authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _pwController.text.trim(),
      );

      // Navigate to Home Page on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      // Display success message
      showSnackBar(context, 'Login successful!');
    } catch (e) {
      // Display error message
      showSnackBar(context, 'Error: ${e.toString()}');
      log('Login error: ${e.toString()}');
    } finally {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              color: Colors.grey[700],
              size: 60,
            ),
            const SizedBox(height: 50),
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            MyTextfield(
              hintText: "Email",
              controller: _emailController,
              isObscure: false,
            ),
            const SizedBox(height: 20),
            MyTextfield(
              hintText: "Password",
              controller: _pwController,
              isObscure: true,
            ),
            const SizedBox(height: 25),
            _isLoading
                ? const CircularProgressIndicator()
                : MyButton(
                    text: "Login",
                    onTap: () {
                      log("Login tapped");
                      login(context);
                    },
                  ),
            const SizedBox(height: 25),
            // Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
