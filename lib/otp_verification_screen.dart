import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math'; // For generating OTP

class OtpVerificationScreen extends StatefulWidget {
  final String? email; // Optional email to display (you might pass this from signup)

  const OtpVerificationScreen({super.key, this.email});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());
  bool isVerifying = false;
  String _generatedOtp = ''; // Store the generated OTP

  @override
  void initState() {
    super.initState();
    _generatedOtp = _generateRandomOtp(); // Generate OTP when screen loads
    print('Generated OTP: $_generatedOtp'); // IMPORTANT: Log for testing only. In production, remove this!
    // In a real app, you would send this _generatedOtp to the user's email/phone number
  }

  String _generateRandomOtp() {
    Random random = Random();
    return List.generate(6, (_) => random.nextInt(10).toString()).join();
  }

  void verifyOtp() {
    String enteredOtp = otpControllers.map((controller) => controller.text).join();

    // --- STEP 1: Basic validation (check if 6 digits are entered) ---
    if (enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid 6-digit OTP."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop here if OTP is incomplete
    }

    setState(() {
      isVerifying = true; // Show loading indicator
    });

    // --- STEP 2: Simulate network request for verification ---
    // In a real application, this would be an API call to your backend
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isVerifying = false; // Hide loading indicator
      });

      // --- STEP 3: Perform the actual verification check ---
      if (enteredOtp == _generatedOtp) {
        // OTP is correct, show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Verified Successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // --- STEP 4: ONLY navigate AFTER successful verification ---
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/login'); // Redirect to login or home screen
        });
      } else {
        // OTP is incorrect, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Incorrect OTP. Please try again."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        // Optionally clear the OTP fields for a new attempt
        for (var controller in otpControllers) {
          controller.clear();
        }
        FocusScope.of(context).requestFocus(otpFocusNodes.first); // Focus the first field
      }
    });
  }

  void handleOtpInput(String value, int index) {
    if (value.isNotEmpty) {
      // Move focus to the next field if a digit is entered
      if (index < 5) {
        FocusScope.of(context).requestFocus(otpFocusNodes.elementAtOrNull(index + 1));
      } else {
        // If it's the last field, unfocus keyboard
        otpFocusNodes.last.unfocus();
        verifyOtp(); // Attempt verification immediately if all fields are filled
      }
    } else if (value.isEmpty && index > 0) {
      // If a digit is deleted, move focus to the previous field
      FocusScope.of(context).requestFocus(otpFocusNodes.elementAtOrNull(index - 1));
    }
  }

  void handleBackspace(KeyEvent event, int index) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (index > 0 && otpControllers.elementAtOrNull(index)?.text.isEmpty == true) {
        FocusScope.of(context).requestFocus(otpFocusNodes.elementAtOrNull(index - 1));
      }
    }
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // Back arrow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'OTP VERIFICATION',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Ensure title is visible
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.grey,
                    offset: Offset(1.5, 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter the OTP sent to your registered email${widget.email != null ? ' (${widget.email})' : ''}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black), // Ensure instruction text is visible
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => RawKeyboardListener(
                  focusNode: FocusNode(), // Local FocusNode for RawKeyboardListener
                  onKey: (event) => handleBackspace(event as KeyEvent, index),
                  child: Container(
                    width: 40,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2), // Visible border
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: otpControllers.elementAtOrNull(index),
                      focusNode: otpFocusNodes.elementAtOrNull(index),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Ensure OTP numbers are visible
                      keyboardType: TextInputType.number,
                      maxLength: 1, // Only one digit per field
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits
                      decoration: const InputDecoration(
                        counterText: "", // Hide character counter
                        border: InputBorder.none, // Hide default TextField border
                      ),
                      onChanged: (value) => handleOtpInput(value, index),
                      onSubmitted: (value) {
                        if (index == 5) verifyOtp(); // Verify if Enter is pressed on the last field
                      },
                      onEditingComplete: () {
                         // This is called when the user hits 'Done'/'Check' on the keyboard.
                         // We're already handling focus movement with onChanged and onSubmitted,
                         // so we can just unfocus here.
                         FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVerifying ? null : verifyOtp, // Disable button during verification
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: isVerifying
                  ? const CircularProgressIndicator(color: Colors.white) // Show spinner
                  : const Text('Verify OTP', style: TextStyle(color: Colors.white)),
            ),
             const SizedBox(height: 20),
             TextButton(
               onPressed: isVerifying ? null : () {
                 // Resend OTP logic
                 _generatedOtp = _generateRandomOtp(); // Regenerate for testing
                 print('Resent OTP: $_generatedOtp');
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     content: Text("New OTP sent!"),
                     backgroundColor: Colors.blue,
                     duration: Duration(seconds: 2),
                   ),
                 );
                 // Clear fields after resend
                 for (var controller in otpControllers) {
                   controller.clear();
                 }
                 FocusScope.of(context).requestFocus(otpFocusNodes.first);
               },
               child: const Text(
                 'Resend OTP',
                 style: TextStyle(color: Colors.black54, fontSize: 14),
               ),
             ),
          ],
        ),
      ),
    );
  }
}