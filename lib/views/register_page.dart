import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haven/services/auth_service.dart';
import 'package:haven/services/user_sharedpreference.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:haven/views/home_page.dart';
import 'package:haven/widget/my_button_widget.dart';
import 'package:haven/widget/my_textfield_widget.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Email and Password (pw) Controllers
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  final TextEditingController _confirmPwController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final AuthService _authService = AuthService();

  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  bool _isLoading = false;

  // Register method
  void register(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _pwController.text.trim();
    String confirmPassword = _confirmPwController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty) {
      showSnackBar(context, 'Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      showSnackBar(context, 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign up the user
      UserCredential userCredential =
          await _authService.signUpWithEmailPassword(email, password);

      // Save the user's name and email in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': name, 'email': email});

      // Re-fetch the current user to ensure it's initialized
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User is not initialized after registration.');
      }

      // Set the new user flag
      await _sharedPreferencesService.setNewUser(true);

      // Save user details locally (optional)
      await _sharedPreferencesService.saveUserDetails(email: email, name: name);

      // Navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      showSnackBar(context, 'Registration successful');
      log('Registration successful');
    } catch (e) {
      log('Error during registration: $e');
      showSnackBar(context, 'Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                "Let's create an account",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextfield(
                hintText: "Name",
                controller: _nameController,
                isObscure: false,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "Confirm Password",
                controller: _confirmPwController,
                isObscure: true,
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      text: "Sign Up",
                      onTap: () {
                        register(context);
                      },
                    ),
              const SizedBox(height: 25),
              // Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Login Now",
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
      ),
    );
  }
}
