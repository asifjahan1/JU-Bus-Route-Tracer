import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_demo/pages/auth_service.dart';
import 'package:google_map_demo/pages/login_page.dart';
import 'package:google_map_demo/pages/welcome_screen.dart';
import 'package:lottie/lottie.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController registrationNoController =
      TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

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
                MaterialPageRoute(builder: (context) => welcomeScreen()));
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'images/sign-up.json',
                      width: 140,
                      height: 140,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Registration',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15),
                    // ID field
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: 'Please Enter Full ID',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ID';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Registration number field
                    TextFormField(
                      controller: registrationNoController,
                      decoration: InputDecoration(
                        hintText: 'Registration Number',
                        prefixIcon: Icon(Icons.confirmation_number_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your registration number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      elevation: 5,
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await authService.register(
                            idController.text,
                            registrationNoController.text,
                          );

                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          } else {
                            // Handle registration failure
                          }
                        }
                      },
                      child: const Text(
                        "SignUp",
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
      ),
    );
  }
}
