import 'package:flutter/material.dart';
import 'food_scanner_screen.dart'; // This import is correct for your scanner button
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'user_profile_screen.dart'; // <--- NEW: Import the UserProfileScreen

class SmartBiteHome extends StatelessWidget {
  final void Function()? onToggleTheme;

  SmartBiteHome({super.key, this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = theme.iconTheme.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final screenWidth = MediaQuery.of(context).size.width;

    const int calorieGoal = 1800;
    const int caloriesConsumed = 500;
    const int carbs = 195;
    const int fat = 10;
    const int protein = 38;
    const int maxCarbs = 230;
    const int maxFat = 50;
    const int maxProtein = 100;

    final int caloriesRemaining =
        (calorieGoal - caloriesConsumed).clamp(0, calorieGoal);
    final double calorieProgress =
        calorieGoal == 0 ? 0.0 : caloriesConsumed / calorieGoal;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leadingWidth: 48.0,
        // --- MODIFIED: Change Icon to IconButton for the Profile ---
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton( // Changed from Icon to IconButton
            icon: Icon(Icons.person, color: theme.appBarTheme.foregroundColor),
            onPressed: () {
              // Navigate to the UserProfileScreen when the button is pressed.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
            tooltip: 'View Profile', // Add a tooltip for better UX
          ),
        ),
        // --- END MODIFIED ---
        title: const Text(
          'SMARTBITE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          if (onToggleTheme != null)
            IconButton(
              key: const Key('themeToggleButton'),
              icon: Icon(
                Icons.brightness_6,
                color: isLight ? Colors.black87 : Colors.white,
              ),
              onPressed: onToggleTheme,
              tooltip: isLight ? 'Switch to Dark Mode' : 'Switch to Light Mode',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                key: const Key('caloriesContainer'),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: CircularPercentIndicator(
                        key: ValueKey<double>(calorieProgress),
                        radius: screenWidth * 0.2,
                        lineWidth: 10.0,
                        percent: calorieProgress.clamp(0.0, 1.0),
                        center: Text(
                          "$caloriesRemaining\nRemaining",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.greenAccent, fontSize: 18),
                        ),
                        progressColor: Colors.greenAccent,
                        backgroundColor: Colors.white24,
                        ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatColumn(icon: Icons.flag, label: "$calorieGoal"),
                        _StatColumn(
                            icon: Icons.restaurant, label: "$caloriesConsumed"),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                key: const Key('macrosContainer'),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Macros",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MacroCircle(
                            label: "Carbohydrates",
                            value: carbs,
                            max: maxCarbs,
                            color: Colors.lightGreen),
                        MacroCircle(
                            label: "Fat",
                            value: fat,
                            max: maxFat,
                            color: Colors.orangeAccent),
                        MacroCircle(
                            label: "Protein",
                            value: protein,
                            max: maxProtein,
                            color: Colors.purpleAccent),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.search, color: iconColor),
                  // This is your existing scanner button
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: iconColor),
                    onPressed: () {
                      // Navigate to the scanner screen when the button is pressed.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodScannerScreen(),
                        ),
                      );
                    },
                    tooltip: 'Scan Food',
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Macro progress widget (remains unchanged)
class MacroCircle extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  MacroCircle({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final double progress = max == 0 ? 0.0 : value / max;

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 6.0,
          percent: progress.clamp(0.0, 1.0),
          center: Text(
            "$value / $max",
            style: TextStyle(fontSize: 10, color: textColor),
          ),
          progressColor: color,
          backgroundColor: Colors.white24,
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: textColor, fontSize: 12)),
      ],
    );
  }
}

// Calorie/Macro summary stat (remains unchanged)
class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;

  _StatColumn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Column(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: textColor)),
      ],
    );
  }
}