// lib/models/food_entry.dart
class FoodEntry {
  int? id;
  final String name;
  String mealType;
  double numberOfServings;
  String servingSizeUnit;
  double calories;
  double carbs;
  double fat;
  double protein;
  DateTime entryDate;

  FoodEntry({
    this.id,
    required this.name,
    this.mealType = 'Lunch',
    this.numberOfServings = 1.0,
    this.servingSizeUnit = 'g',
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.entryDate,
  });

  // Add this copy constructor/method
  FoodEntry.copy(FoodEntry other)
      : id = other.id,
        name = other.name,
        mealType = other.mealType,
        numberOfServings = other.numberOfServings,
        servingSizeUnit = other.servingSizeUnit,
        calories = other.calories,
        carbs = other.carbs,
        fat = other.fat,
        protein = other.protein,
        entryDate = other.entryDate;


  double getTotalCalories() => calories * numberOfServings;
  double getTotalCarbs() => carbs * numberOfServings;
  double getTotalFat() => fat * numberOfServings;
  double getTotalProtein() => protein * numberOfServings;

  // Add toMap and fromMap if you plan to use database later (already discussed)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mealType': mealType,
      'numberOfServings': numberOfServings,
      'servingSizeUnit': servingSizeUnit,
      'calories': calories,
      'carbs': carbs,
      'fat': fat,
      'protein': protein,
      'entryDate': entryDate.toIso8601String().substring(0, 10),
    };
  }

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    return FoodEntry(
      id: map['id'] as int?,
      name: map['name'] as String,
      mealType: map['mealType'] as String,
      numberOfServings: map['numberOfServings'] as double,
      servingSizeUnit: map['servingSizeUnit'] as String,
      calories: (map['calories'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      entryDate: DateTime.parse(map['entryDate'] as String),
    );
  }
}