import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        throw Exception(
            'Email is not verified. Please verify your email before signing in.');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Create user with additional details
  Future<String> createUser({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    // Check if passwords match
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    try {
      // Create a user using Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the created user's ID
      String userId = userCredential.user!.uid;

      // Save additional user details in Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
      });

      return 'User created successfully';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Sign out
  Future<void> signOut() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        await _auth.signOut();
      } catch (e) {
        throw Exception('Error while signing out: ${e.toString()}');
      }
    } else {
      throw Exception('No user is currently logged in.');
    }
  }
}
