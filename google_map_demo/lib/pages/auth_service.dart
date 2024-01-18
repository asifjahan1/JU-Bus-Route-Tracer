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
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> register(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    return true;
  }

  Future<bool> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail == email && storedPassword == password) {
      return true;
    } else {
      return false;
    }
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
