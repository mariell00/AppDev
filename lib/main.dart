import 'package:flutter/material.dart';
import 'login_page.dart'; 

void main() {
  runApp(SmartBiteApp());
}

class SmartBiteApp extends StatelessWidget {
  const SmartBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), 
  }
}
