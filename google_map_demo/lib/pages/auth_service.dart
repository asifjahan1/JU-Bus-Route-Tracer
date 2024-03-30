// class AuthService {
//   static String? _registeredEmail;
//   static String? _registeredPassword;

//   Future<bool> register(String email, String password) async {
//     // Simulate registration logic
//     // Return true if registration is successful, false otherwise
//     _registeredEmail = email;
//     _registeredPassword = password;
//     return true;
//   }

//   Future<bool> login(String email, String password) async {
//     // Simulate login logic
//     // Check if the provided email and password match the registered user
//     if (_registeredEmail == email && _registeredPassword == password) {
//       return true; // Login successful
//     } else {
//       return false; // Email or password incorrect
//     }
//   }
// }
//
//

//using Shared-preference
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user with email and password
  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await sendEmailVerification();

      return true; // Registration successful
    } catch (e) {
      print("Error registering user: $e");
      return false; // Registration failed
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print("Error sending email verification: $e");
    }
  }

  // Login user with email and password
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Login successful
    } catch (e) {
      print("Error logging in: $e");
      return false; // Login failed
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }
}

// // Using Firebase
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Example function for user registration
//   Future<User?> registerWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       User? user = result.user;
//       return user;
//     } catch (error) {
//       print(error.toString());
//       return null;
//     }
//   }

//   // Example function for user sign-in
//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       User? user = result.user;
//       return user;
//     } catch (error) {
//       print(error.toString());
//       return null;
//     }
//   }
// }
