import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:haven/services/auth_service.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/widget/my_button_widget.dart';
import 'package:haven/widget/my_textfield_widget.dart';
import 'package:haven/views/register_page.dart';

class LoginPage extends StatelessWidget {
  // Email and Password (pw) Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  LoginPage({
    super.key,
  });

  // Login Method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // Login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );

      showSnackBar(context, 'Login successful!');
    } catch (e) {
      showSnackBar(context, e.toString());
      log(e.toString());
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
            MyButton(
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
