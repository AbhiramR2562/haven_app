import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haven/views/home_page.dart';
import 'package:haven/views/register_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // If the snapshot has data
            if (snapshot.hasData) {
              // show the HomePage
              return HomePage();
            } else {
              return RegisterPage();
            }
          }),
    );
  }
}
