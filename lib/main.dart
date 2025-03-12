import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'login_page.dart'; // Import the login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppDev',
      home: LoginPage(),
    );
  }
}
