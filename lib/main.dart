import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'sign_up_screen.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';
import 'main_screen.dart';
import 'forget_password.dart'; // Updated file and class name

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartBite',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color.fromARGB(255, 25, 23, 23),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/main': (context) => const MainScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(), // Updated class and route
      },
    );
  }
}
