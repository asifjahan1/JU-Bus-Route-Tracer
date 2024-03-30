// import 'package:flutter/material.dart';
// import 'package:google_map_demo/pages/registration_page.dart';

// void main() {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //     /*
//   //     name: "demo",
//   //     options: FirebaseOptions(
//   //       apiKey: "AIzaSyC9W1rv3Db_A9TcnpyVlzBsngdCQHuiFlU",
//   //       appId: "1:531572016920:android:e35b37d59f8af589fe806d",
//   //       messagingSenderId: "531572016920",
//   //       projectId: "fir-cfdec",
//   //       databaseURL:
//   //           "https://fir-cfdec-default-rtdb.asia-southeast1.firebasedatabase.app",

//   //     )
//   //     */

//   //     //eitar niche theke sobgulai final options
//   //     // name: "Google-Map-Demo",
//   //     // options: FirebaseOptions(
//   //     //   apiKey:
//   //     //       "AIzaSyDNToFfTa1a7WqcxS1PlC382Oem1MpHeHA", //new api key genrated on 12012024
//   //     //   appId:
//   //     //       "1:954100295518:android:b77f999046b54a0472d1cf", //new aap id from json
//   //     //   messagingSenderId: "954100295518", //new sender id
//   //     //   projectId: "map-demo-c4c2c", //new project ID
//   //     //   databaseURL:
//   //     //       "https://map-demo-c4c2c-default-rtdb.asia-southeast1.firebasedatabase.app/", //new databaseUrl created in 13012024
//   //     // ),
//   //     );
//   runApp(MyApp());
// }

// // @override
// //   void initState() {
// //     super.initState();
// //     Firebase.initializeApp().whenComplete(() {
// //       print("completed");
// //       setState(() {});
// //     });
// //   }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       //initialRoute: splashRoute,
//       //routes: routes,
//       title: 'Google Map Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//         ),
//         useMaterial3: true,
//       ),
//       //home: welcomeScreen(),
//       home: RegistrationPage(),
//     );
//   }
// }

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_demo/pages/map_page.dart';
import 'package:google_map_demo/pages/schedule_page.dart';
import 'package:google_map_demo/pages/welcome_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized

  // Initialize Firebase with options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JU Bus Route Tracer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/', // Set initial route to '/'
      routes: {
        '/': (context) =>
            const welcomeScreen(), // Define route for welcome screen
        '/map': (context) => MapPage(
            userStartLocation:
                const LatLng(0.0, 0.0)), // Define route for map page
        '/schedule': (context) =>
            const SchedulePage(), // Define route for SchedulePage
      },
    );
  }
}

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Trigger the directions API request when the button is pressed
//             DirectionsService().getDirections();
//           },
//           child: Text('Get Directions'),
//         ),
//       ),
//     );
//   }
// }
