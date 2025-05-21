// lib/edit_entry_screen.dart
import 'package:flutter/material.dart';
import 'models/food_entry.dart';

class EditEntryScreen extends StatefulWidget {
  final FoodEntry foodEntry;

  const EditEntryScreen({super.key, required this.foodEntry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late FoodEntry _currentEntry;
  late TextEditingController _servingSizeController;
  late String _selectedMealType;
  late String _selectedServingUnit;

  // Extend this list to include all units you might use in your mock data
  final List<String> _servingSizeUnitOptions = [
    'g',
    'ml',
    'cup',
    'serving',
    'item',
    'egg', // <--- ADD THIS LINE
    'oz',
    'lb',
    'unit', // A more generic catch-all if needed
  ];
  final List<String> _mealTypeOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    _currentEntry = FoodEntry.copy(widget.foodEntry); // Create a mutable copy
    _servingSizeController =
        TextEditingController(text: _currentEntry.numberOfServings.toString());
    _selectedMealType = _currentEntry.mealType;

    // Ensure the current serving size unit is in the options.
    // If not, default to 'serving' or add it.
    if (!_servingSizeUnitOptions.contains(_currentEntry.servingSizeUnit)) {
      _servingSizeUnitOptions.add(_currentEntry.servingSizeUnit); // Add if missing
    }
    _selectedServingUnit = _currentEntry.servingSizeUnit;
  }

  @override
  void dispose() {
    _servingSizeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _currentEntry = FoodEntry(
        id: _currentEntry.id, // Preserve ID if it exists
        name: _currentEntry.name,
        mealType: _selectedMealType,
        numberOfServings: double.tryParse(_servingSizeController.text) ?? _currentEntry.numberOfServings,
        servingSizeUnit: _selectedServingUnit,
        calories: _currentEntry.calories,
        carbs: _currentEntry.carbs,
        fat: _currentEntry.fat,
        protein: _currentEntry.protein,
        entryDate: _currentEntry.entryDate, // Preserve entry date
      );
    });
    Navigator.pop(context, _currentEntry); // Pass updated entry back
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Entry',
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.green),
            onPressed: _saveChanges,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentEntry.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRow(
                    context,
                    label: 'Meal Type',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMealType,
                        dropdownColor: cardColor, // Match dropdown background to card
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedMealType = newValue;
                            });
                          }
                        },
                        items: _mealTypeOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: textColor)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  _buildRow(
                    context,
                    label: 'Servings',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _servingSizeController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedServingUnit,
                            dropdownColor: cardColor,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedServingUnit = newValue;
                                });
                              }
                            },
                            items: _servingSizeUnitOptions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: textColor)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Nutritional Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nutrition Facts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 16),
                  _buildNutritionRow(
                    context,
                    label: 'Total Calories',
                    value: '${_currentEntry.getTotalCalories().toStringAsFixed(0)} kcal',
                    isTotal: true,
                  ),
                  const Divider(),
                  _buildNutritionRow(
                    context,
                    label: 'Carbs',
                    value: '${_currentEntry.getTotalCarbs().toStringAsFixed(1)} g',
                  ),
                  _buildNutritionRow(
                    context,
                    label: 'Fat',
                    value: '${_currentEntry.getTotalFat().toStringAsFixed(1)} g',
                  ),
                  _buildNutritionRow(
                    context,
                    label: 'Protein',
                    value: '${_currentEntry.getTotalProtein().toStringAsFixed(1)} g',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, {required String label, required Widget child}) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: textColor)),
        child,
      ],
    );
  }

  Widget _buildNutritionRow(BuildContext context, {required String label, required String value, bool isTotal = false}) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Make sure FoodEntry has a copy constructor or method
// lib/models/food_entry.dart
// Add this method to your FoodEntry class if it's not already there:
/*
  FoodEntry copy(FoodEntry other) {
    return FoodEntry(
      id: other.id,
      name: other.name,
      mealType: other.mealType,
      numberOfServings: other.numberOfServings,
      servingSizeUnit: other.servingSizeUnit,
      calories: other.calories,
      carbs: other.carbs,
      fat: other.fat,
      protein: other.protein,
      entryDate: other.entryDate,
    );
  }
*/