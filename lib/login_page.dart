import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Google Sign-In Function
  Future<void> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        print('Google Sign-In successful: ${account.email}');
      }
    } catch (error) {
      print('Google Sign-In failed: $error');
    }
  }

  // Facebook Sign-In Function
  Future<void> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        print('Facebook Sign-In successful: ${userData['email']}');
      } else {
        print('Facebook Sign-In failed: ${result.status}');
      }
    } catch (error) {
      print('Facebook Sign-In error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SMARTBITE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your Personalized Food Tracker & Nutrition Guide',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Your Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR'),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _signInWithGoogle,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/google.png'),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: _signInWithFacebook,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/facebook.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
