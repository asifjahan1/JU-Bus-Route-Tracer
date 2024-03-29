import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_demo/pages/auth_service.dart';
import 'package:google_map_demo/pages/map_page.dart';
import 'package:google_map_demo/pages/welcome_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool _obsecureText = true;

  Future<LocationData> _fetchLocation() async {
    var location = Location();
    LocationData currentLocation = await location.getLocation();
    return currentLocation;
  }

  void handleLogin(BuildContext context) async {
    LocationData? currentLocation = await _fetchLocation();

    if (currentLocation != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(
            userStartLocation: LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            ),
          ),
        ),
      );
    } else {
      // Handle location not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const welcomeScreen()));
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('images/user-anime.json',
                      width: 100, height: 100, fit: BoxFit.fill),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                        fontSize: 34, fontWeight: FontWeight.w700),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Please Enter Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _obsecureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Icon(
                          _obsecureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Please Enter Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    elevation: 5,
                    color: Colors.deepPurple,
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      bool success = await authService.login(
                        emailController.text,
                        passwordController.text,
                      );

                      if (success) {
                        handleLogin(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email or password incorrect'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
