import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool showPassword = false;

  void _login() {
    setState(() {
      emailError = _validateEmail(emailController.text);
      passwordError = _validatePassword(passwordController.text);
    });

    if (emailError == null && passwordError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in as ${emailController.text}')),
      );
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Enter email';
    final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'Enter password';
    if (value.length < 6) return 'Min 6 chars';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Needs number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black54, blurRadius: 8, spreadRadius: 2),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    errorText: emailError,
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() => emailError = _validateEmail(value)),
                ),
                Divider(color: Colors.grey[700]),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    errorText: passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: !showPassword,
                  onChanged: (value) => setState(() => passwordError = _validatePassword(value)),
                ),
                Divider(color: Colors.grey[700]),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  ),
                  child: Text("Login", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Redirecting to Sign Up...')),
                    );
                  },
                  child: Text("Sign Up", style: TextStyle(color: Colors.blueGrey[300], fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
