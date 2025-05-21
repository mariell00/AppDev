// lib/search_food_screen.dart
import 'package:flutter/material.dart';
import 'models/food_entry.dart'; // Ensure FoodEntry is imported if needed for mock data

class SearchFoodScreen extends StatefulWidget {
  final String? preselectedMealType; // New: Optional meal type to pre-select

  const SearchFoodScreen({super.key, this.preselectedMealType});

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  String? _selectedMeal; //
  final List<String> _mealOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack']; //

  // Mock search results (replace with actual search logic later)
  final List<Map<String, dynamic>> _mockSearchResults = [
    {'name': 'White rice, Cooked', 'calories': 1.29, 'carbs': 0.28, 'fat': 0.003, 'protein': 0.027}, // per gram
    {'name': 'Boiled eggs', 'calories': 78.0, 'carbs': 0.6, 'fat': 5.3, 'protein': 6.3}, // per egg
    {'name': 'Chicken Breast', 'calories': 1.65, 'carbs': 0.0, 'fat': 0.036, 'protein': 0.31}, // per gram
    {'name': 'Apple', 'calories': 95.0, 'carbs': 25.0, 'fat': 0.3, 'protein': 0.5}, // per medium apple
    {'name': 'Banana', 'calories': 105.0, 'carbs': 27.0, 'fat': 0.3, 'protein': 1.3},
    {'name': 'Oatmeal', 'calories': 150.0, 'carbs': 27.0, 'fat': 3.0, 'protein': 5.0},
    {'name': 'Spinach', 'calories': 23.0, 'carbs': 3.6, 'fat': 0.4, 'protein': 2.9},
  ];

  List<Map<String, dynamic>> _filteredSearchResults = [];

  // Mock search history data
  final List<Map<String, String>> _searchHistory = [
    {'name': 'White rice, Cooked', 'details': '252 cal, 195 g'},
    {'name': 'Boiled eggs', 'details': '248 cal, 3 egg'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.preselectedMealType ?? _mealOptions.first; // Use preselected or default to first
    _filteredSearchResults = _mockSearchResults; // Initially show all mock results
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSearchResults = _mockSearchResults;
      } else {
        _filteredSearchResults = _mockSearchResults
            .where((food) => food['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final iconColor = theme.iconTheme.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedMeal,
            icon: Icon(Icons.arrow_drop_down, color: textColor),
            style: TextStyle(color: textColor, fontSize: 18),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMeal = newValue;
              });
            },
            items: _mealOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            dropdownColor: cardColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a food', //
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
                style: TextStyle(color: textColor),
                onChanged: _onSearchChanged, // Update search results as user types
                onSubmitted: (query) {
                  // In a real app, you would perform a search here
                  print('Searching for: $query');
                  // This snackbar is for debugging, can be removed later
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Searching for "$query"')),
                  // );
                },
              ),
              const SizedBox(height: 24),
              if (_filteredSearchResults.isNotEmpty && _filteredSearchResults.length < _mockSearchResults.length)
                // Show filtered results if search query is active
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._filteredSearchResults.map((food) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: cardColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(
                            food['name']!,
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${food['calories'].toStringAsFixed(0)} cal per unit (mock)',
                            style: TextStyle(color: textColor.withOpacity(0.7)),
                          ),
                          onTap: () {
                            // Return selected food details to the previous screen (DiaryScreen)
                            Navigator.pop(context, {
                              'name': food['name'],
                              'mealType': _selectedMeal, // Pass the currently selected meal type
                              'calories': food['calories'],
                              'carbs': food['carbs'],
                              'fat': food['fat'],
                              'protein': food['protein'],
                            });
                          },
                        ),
                      ),
                    )).toList(),
                  ],
                )
              else // Show history if no active search or no results
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'History', //
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._searchHistory.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: cardColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(
                            item['name']!,
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            item['details']!, //
                            style: TextStyle(color: textColor.withOpacity(0.7)),
                          ),
                          onTap: () {
                            // Simulate selecting a historical item and returning its details
                            final selectedFood = _mockSearchResults.firstWhere(
                              (food) => food['name'] == item['name'],
                              orElse: () => {'name': item['name'], 'calories': 0.0, 'carbs': 0.0, 'fat': 0.0, 'protein': 0.0},
                            );

                            Navigator.pop(context, {
                              'name': selectedFood['name'],
                              'mealType': _selectedMeal, // Pass the currently selected meal type
                              'calories': selectedFood['calories'],
                              'carbs': selectedFood['carbs'],
                              'fat': selectedFood['fat'],
                              'protein': selectedFood['protein'],
                            });
                          },
                        ),
                      ),
                    )).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}