// lib/smartbite_home.dart
import 'package:flutter/material.dart';
import 'food_scanner_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'user_profile_screen.dart';
import 'notifications_screen.dart';
import 'search_food_screen.dart'; // <--- NEW: Import SearchFoodScreen

class SmartBiteHome extends StatelessWidget {
  final void Function()? onToggleTheme;

  SmartBiteHome({super.key, this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.person, color: theme.appBarTheme.foregroundColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
            tooltip: 'View Profile',
          ),
        ),
        title: Text(
          'SMARTBITE',
          style: theme.textTheme.headlineLarge?.copyWith(color: Colors.green),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: theme.appBarTheme.foregroundColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            tooltip: 'Notifications',
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
              // REMOVED AbsorbPointer AND GestureDetector around TextField
              // Instead, we make the TextField interactive AND keep the scanner button interactive
              TextField(
                readOnly: true, // Make it read-only so keyboard doesn't pop up
                onTap: () { // This onTap will trigger when the TextField itself is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchFoodScreen(), // Navigate to SearchFoodScreen
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search for a food',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: iconColor),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: iconColor),
                    onPressed: () {
                      // This button will now navigate to FoodScannerScreen from home
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodScannerScreen(),
                        ),
                      );
                    },
                    tooltip: 'Scan Food',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
                style: TextStyle(color: textColor),
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

  const MacroCircle({ // Added const
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

  const _StatColumn({super.key, required this.icon, required this.label}); // Added const and super.key

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