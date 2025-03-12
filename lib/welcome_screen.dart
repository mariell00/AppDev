import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset('assets/logo.png', width: 100), // Add your logo
            const SizedBox(height: 20),
            const Text(
              'Welcome to SmartBite',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),

            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');


              },
              child: const Text(
                'Get Started',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
