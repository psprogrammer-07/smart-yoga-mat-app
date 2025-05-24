import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core
import 'screens/Homepage.dart';
import 'screens/control_screen.dart';
import 'screens/product_showcase.dart';
import 'screens/settings/lota_update_screen.dart';
import 'screens/settings/app_info_screen.dart';

Future<void> main() async { // Make main async and return Future<void>
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Yoga Mat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: Colors.black87,
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const SplashScreen(), 
        '/homeScreen':(context)=>Homepage(),// Map '/' to ConnectScreen
        '/control': (context) => ControlScreen(),
        '/showcase': (context) => const ProductShowcaseScreen(),
        '/ota': (context) => const IOTAUpdateScreen(),
        '/info': (context) =>  AppInfoScreen(),
      },
    );
  }
}

