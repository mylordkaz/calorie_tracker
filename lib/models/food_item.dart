import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 0)
class FoodItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double calories;

  @HiveField(4)
  double protein;

  @HiveField(5)
  double carbs;

  @HiveField(6)
  double fat;

  @HiveField(7)
  String unit; // '100g', 'item', 'serving'

  @HiveField(8)
  double? unitWeight; // weight in grams if unit is : serving

  @HiveField(9)
  String? servingDescription;

  @HiveField(10)
  Map<String, double>? customMacros;

  @HiveField(11)
  DateTime createdAt;

  @HiveField(12)
  DateTime lastUsed;

  @HiveField(13)
  int useCount; // for "recent foods" functionality

  @HiveField(14)
  String? imagePath;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.unit = '100g',
    this.unitWeight,
    this.servingDescription,
    this.customMacros,
    required this.createdAt,
    required this.lastUsed,
    this.useCount = 0,
    this.imagePath,
  });

  // Convert to grams for meal calculations
  double getGramsPerUnit() {
    switch (unit) {
      case '100g':
        return 100.0;
      case 'per_item':
        return unitWeight ?? 1.0; // Default to 1g if no weight specified
      case 'serving':
        return unitWeight ?? 1.0; // Default to 1g if no weight specified
      default:
        return 100.0;
    }
  }

  // Calculate macros for a specific quantity in grams
  Map<String, double> getMacrosForGrams(double grams) {
    final gramsPerUnit = getGramsPerUnit();
    final multiplier = grams / gramsPerUnit;

    Map<String, double> macros = {
      'calories': calories * multiplier,
      'protein': protein * multiplier,
      'carbs': carbs * multiplier,
      'fat': fat * multiplier,
    };

    // Add custom macros
    if (customMacros != null) {
      customMacros!.forEach((key, value) {
        macros[key] = value * multiplier;
      });
    }

    return macros;
  }

  // Helper methods for individual macros
  double getCaloriesForGrams(double grams) =>
      getMacrosForGrams(grams)['calories']!;
  double getProteinForGrams(double grams) =>
      getMacrosForGrams(grams)['protein']!;
  double getCarbsForGrams(double grams) => getMacrosForGrams(grams)['carbs']!;
  double getFatForGrams(double grams) => getMacrosForGrams(grams)['fat']!;

  // Display helpers
  String getDisplayUnit() {
    switch (unit) {
      case 'per_item':
        return 'per item';
      case 'serving':
        return servingDescription != null
            ? 'per ${servingDescription!}'
            : 'per serving';
      case '100g':
      default:
        return 'per 100g';
    }
  }

  String getFullDescription() {
    if (unit == 'serving' && servingDescription != null) {
      if (unitWeight != null) {
        return '${servingDescription!} (${unitWeight!.toInt()}g)';
      }
      return servingDescription!;
    }
    return getDisplayUnit();
  }
}
