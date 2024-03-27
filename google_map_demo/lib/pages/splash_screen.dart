import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_map_demo/pages/login_page.dart';
import 'package:google_map_demo/pages/welcome_screen.dart';
import 'package:google_map_demo/shared_preference.dart';
//import 'package:flutter/src/services/asset_manifest.dart';

// ignore: camel_case_types
class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

// ignore: camel_case_types
class _splashScreenState extends State<splashScreen> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    // This method is called when the state object is inserted into the tree.

    // Read cache asynchronously using the _prefService
    _prefService.readCache("email").then((value) {
      if (kDebugMode) {
        print(value.toString());
      } // Print the value for debugging purposes

      // Use a Timer to delay the navigation for 1 second
      Timer(
        const Duration(seconds: 1),
        () {
          // If the value is not null (user is logged in), navigate to homeRoute
          if (value != null) {
            Navigator.of(context)
                .pushReplacementNamed(const welcomeScreen() as String);
          } else {
            // If the value is null (user is not logged in), navigate to welcomeRoute
            Navigator.of(context)
                .pushReplacementNamed(const LoginPage() as String);
          }
        },
      );
    });

    // Call the superclass' initState method
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset(
                  "images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
