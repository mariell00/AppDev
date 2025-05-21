import 'package:flutter/material.dart';

class DiaryScreen extends StatefulWidget {
  final void Function()? onToggleTheme;

  DiaryScreen({super.key, this.onToggleTheme});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime selectedDate = DateTime.now();

  void _changeDay(int offset) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: offset));
    });
  }

  String _getDayLabel(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    } else if (date
        .add(const Duration(days: 1))
        .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      return 'Yesterday';
    } else if (date
        .subtract(const Duration(days: 1))
        .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      return 'Tomorrow';
    } else {
      return "${date.month}/${date.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Diary",
          style: TextStyle(color: theme.appBarTheme.foregroundColor), // Use appBarTheme.foregroundColor
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor, // Use appBarTheme.foregroundColor for default icons/text
        elevation: 0,
        actions: [
          if (widget.onToggleTheme != null)
            IconButton(
              icon: Icon(Icons.brightness_6, color: theme.appBarTheme.foregroundColor), // Use appBarTheme.foregroundColor
              onPressed: widget.onToggleTheme,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Day Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: textColor), // Uses theme text color for icons
                    onPressed: () => _changeDay(-1),
                  ),
                  Text(
                    _getDayLabel(selectedDate),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor), // Uses theme text color
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: textColor), // Uses theme text color for icons
                    onPressed: () => _changeDay(1),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Calorie Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor, // Uses theme card color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CalorieColumn(label: "Goal", value: 1800),
                    _CalorieColumn(label: "Food", value: 500),
                    _CalorieColumn(label: "Remaining", value: 1300),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Meal Cards
              _MealCard(meal: "Breakfast"),
              _MealCard(meal: "Lunch"),
              _MealCard(meal: "Dinner"),
            ],
          ),
        ),
      ),
    );
  }
}

// Calorie summary widget
class _CalorieColumn extends StatelessWidget {
  final String label;
  final int value;

  _CalorieColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            color: textColor, // Uses theme text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7), // Uses theme text color with opacity
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Meal section card
class _MealCard extends StatelessWidget {
  final String meal;

  _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: cardColor, // Uses theme card color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor, // Uses theme text color
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text("ADD FOOD", style: TextStyle(color: Colors.green)), // Fixed green for button
              ),
            ),
          ],
        ),
      ),
    );
  }
}