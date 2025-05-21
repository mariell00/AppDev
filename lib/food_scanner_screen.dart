import 'package:flutter/material.dart';

class FoodScannerScreen extends StatefulWidget {
  const FoodScannerScreen({super.key});

  @override
  _FoodScannerScreenState createState() => _FoodScannerScreenState();
}

class _FoodScannerScreenState extends State<FoodScannerScreen> {
  String _scanResult = "No food detected yet.";
  bool _isScanning = false;

  // Placeholder function for handling the food scan.
  Future<void> _scanFood() async {
    setState(() {
      _isScanning = true; // Show loading indicator
      _scanResult = "Scanning..."; // Initial message
    });

    // Simulate a delay for the AI processing (replace with actual logic)
    await Future.delayed(const Duration(seconds: 3));

    // Simulate different results
    // Replace this with actual AI-powered food recognition logic
    const List<String> possibleResults = [
      "Apple - 95 calories",
      "Banana - 105 calories",
      "Chicken Breast - 165 calories",
      "Salad with Vinaigrette - 150 calories",
      "Pizza Slice - 300 calories",
      "Unknown Food Item", // Add a case where the food is not recognized
    ];
    final String result =
        possibleResults[(DateTime.now().second % possibleResults.length)];

    setState(() {
      _scanResult = result;
      _isScanning = false; // Hide loading indicator
    });

    // Placeholder for backend communication:
    // PUT HERE: Send _scanResult to your backend to store in the user's food log.
    // Example (replace with your actual backend call):
    // try {
    //   await ApiService.postFoodLog(foodName: _scanResult, timestamp: DateTime.now());
    //   // Optionally show a success message
    // } catch (e) {
    //   // Handle errors (e.g., show error message to the user)
    //   print("Error posting food log: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Failed to log food. Please try again.")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Scanner', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Consistent app bar color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Visual representation of a scanner (you can replace with a fancy animation)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 4.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isScanning
                      ? const CircularProgressIndicator(
                          color: Colors.green,
                        ) // Show while scanning
                      : const Icon(
                          Icons.qr_code_scanner,
                          size: 100,
                          color: Colors.green,
                        ), // Show the scanner icon
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _scanResult,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isScanning ? null : _scanFood, // Disable button while scanning
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isScanning ? "Scanning..." : "Start Scan",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Point the scanner at the food item to identify it.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}