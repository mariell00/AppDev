// lib/diary_screen.dart
import 'package:flutter/material.dart';
import 'edit_entry_screen.dart';
import 'models/food_entry.dart';
import 'search_food_screen.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:percent_indicator/circular_percent_indicator.dart'; // For calorie circle

class DiaryScreen extends StatefulWidget {
  final void Function()? onToggleTheme;

  const DiaryScreen({super.key, this.onToggleTheme});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _selectedDate = DateTime.now(); // State to hold the selected date

  // Mock diary entries, grouped by meal type
  // In a real app, this data would change based on _selectedDate
  // Changed to 'final' as recommended
  final Map<String, List<FoodEntry>> _diaryEntriesByMeal = {
    'Breakfast': [
      FoodEntry(
        name: "Boiled eggs",
        mealType: "Breakfast",
        numberOfServings: 3,
        servingSizeUnit: "egg",
        calories: 78,
        carbs: 0.6,
        fat: 5.3,
        protein: 6.3,
        entryDate: DateTime.now(), // Added required entryDate
      ),
    ],
    'Lunch': [
      FoodEntry(
        name: "White rice, Cooked",
        mealType: "Lunch",
        numberOfServings: 195,
        servingSizeUnit: "g",
        calories: 1.29,
        carbs: 0.28,
        fat: 0.003,
        protein: 0.027,
        entryDate: DateTime.now(), // Added required entryDate
      ),
      FoodEntry(
        name: "Chicken Breast",
        mealType: "Lunch",
        numberOfServings: 120,
        servingSizeUnit: "g",
        calories: 1.65,
        carbs: 0,
        fat: 0.036,
        protein: 0.31,
        entryDate: DateTime.now(), // Added required entryDate
      ),
    ],
    'Dinner': [],
    'Snack': [
      FoodEntry(
        name: "Apple",
        mealType: "Snack",
        numberOfServings: 1,
        servingSizeUnit: "medium",
        calories: 95,
        carbs: 25,
        fat: 0.3,
        protein: 0.5,
        entryDate: DateTime.now(), // Added required entryDate
      ),
    ],
  };

  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  void _addFoodEntry(FoodEntry newEntry) {
    setState(() {
      // Ensure the new entry has the currently selected date if it's not already set
      // (though it should be set when creating it from SearchFoodScreen now)
      newEntry.entryDate = _selectedDate;
      _diaryEntriesByMeal[newEntry.mealType]?.add(newEntry);
    });
  }

  void _updateFoodEntry(FoodEntry originalEntry, FoodEntry updatedEntry) {
    setState(() {
      // Remove from original meal type
      _diaryEntriesByMeal[originalEntry.mealType]?.removeWhere((entry) => entry == originalEntry);

      // Add to new meal type (if meal type changed)
      _diaryEntriesByMeal[updatedEntry.mealType]?.add(updatedEntry);
    });
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      // In a real app, you would refetch _diaryEntriesByMeal based on _selectedDate here
      // For now, it will just change the displayed date.
      // _diaryEntriesByMeal = _fetchEntriesForDate(_selectedDate); // Example
    });
  }

  // Helper to calculate total calories for the current mock day
  double _calculateTotalCaloriesConsumed() {
    double total = 0;
    _diaryEntriesByMeal.values.forEach((mealEntries) {
      mealEntries.forEach((entry) {
        // Only sum entries for the _selectedDate in a real app
        // For mock data, we'll sum all for now.
        total += entry.getTotalCalories();
      });
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final screenWidth = MediaQuery.of(context).size.width;

    const int calorieGoal = 1800; // Mock goal
    final double caloriesConsumed = _calculateTotalCaloriesConsumed();
    final int caloriesRemaining =
        (calorieGoal - caloriesConsumed).clamp(0, calorieGoal).toInt();
    final double calorieProgress =
        calorieGoal == 0 ? 0.0 : caloriesConsumed / calorieGoal;


    return Scaffold(
      appBar: AppBar(
        title: Text('Diary', style: TextStyle(color: theme.appBarTheme.foregroundColor)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Date Navigation and Calorie Summary Header ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              color: theme.scaffoldBackgroundColor, // Ensure consistent background
              child: Column(
                children: [
                  // Date Navigation Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
                        onPressed: () => _changeDate(-1),
                      ),
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: textColor, size: 20),
                        onPressed: () => _changeDate(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Calorie Summary Circle
                  Container(
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
                            key: ValueKey<double>(calorieProgress), // Key for animation
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
                                icon: Icons.restaurant, label: "${caloriesConsumed.toStringAsFixed(0)}"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // --- End Date Navigation and Calorie Summary Header ---

            // Meal Sections (previously implemented)
            Padding(
              padding: const EdgeInsets.all(16.0), // Padding for the meal sections
              child: Column(
                children: _mealTypes.map((mealType) {
                  final entries = _diaryEntriesByMeal[mealType] ?? [];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealType,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // List of existing entries
                        if (entries.isNotEmpty)
                          ...entries.map((entry) => Card(
                                color: cardColor,
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  title: Text(entry.name, style: TextStyle(color: textColor)),
                                  subtitle: Text(
                                    '${entry.numberOfServings.toStringAsFixed(0)} ${entry.servingSizeUnit} - ${entry.getTotalCalories().toStringAsFixed(0)} Cal',
                                    style: TextStyle(color: textColor.withOpacity(0.8)),
                                  ),
                                  trailing: const Icon(Icons.edit, color: Colors.green),
                                  onTap: () async {
                                    final updatedEntry = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditEntryScreen(foodEntry: entry),
                                      ),
                                    );
                                    if (updatedEntry != null && updatedEntry is FoodEntry) {
                                      _updateFoodEntry(entry, updatedEntry);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${updatedEntry.name} updated!')),
                                      );
                                    }
                                  },
                                ),
                              )).toList(),
                        // "Add Food" button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final selectedFoodDetails = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchFoodScreen(preselectedMealType: mealType),
                                ),
                              );

                              if (selectedFoodDetails != null && selectedFoodDetails is Map<String, dynamic>) {
                                final newFoodEntry = FoodEntry(
                                  name: selectedFoodDetails['name'],
                                  mealType: selectedFoodDetails['mealType'],
                                  calories: selectedFoodDetails['calories'],
                                  carbs: selectedFoodDetails['carbs'],
                                  fat: selectedFoodDetails['fat'],
                                  protein: selectedFoodDetails['protein'],
                                  numberOfServings: 1.0,
                                  servingSizeUnit: 'g',
                                  entryDate: _selectedDate, // Set the entryDate to the currently selected date
                                );

                                final confirmedEntry = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditEntryScreen(foodEntry: newFoodEntry),
                                  ),
                                );

                                if (confirmedEntry != null && confirmedEntry is FoodEntry) {
                                  _addFoodEntry(confirmedEntry);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${confirmedEntry.name} added to ${confirmedEntry.mealType}!')),
                                  );
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.green.withOpacity(0.7)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: Icon(Icons.add, color: Colors.green),
                            label: Text(
                              'Add Food to $mealType',
                              style: TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusing _StatColumn for calories consumed/goal
class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatColumn({super.key, required this.icon, required this.label}); // Added super.key

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