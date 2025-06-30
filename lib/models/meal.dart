import 'package:hive/hive.dart';
import 'food_item.dart';

part 'meal.g.dart';

@HiveType(typeId: 1)
class MealIngredient extends HiveObject {
  @HiveField(0)
  String foodId;

  @HiveField(1)
  double grams; // Always store in grams for consistency

  // Optional: store the original quantity and unit for display
  @HiveField(2)
  double? originalQuantity; // e.g., 2 (slices), 1.5 (cups)

  @HiveField(3)
  String? originalUnit; // 'items', 'servings', 'grams'

  MealIngredient({
    required this.foodId,
    required this.grams,
    this.originalQuantity,
    this.originalUnit,
  });

  // Helper to create from different input types
  static MealIngredient fromQuantity({
    required String foodId,
    required FoodItem food,
    required double quantity,
    required String inputUnit, // 'grams', 'items', 'servings'
  }) {
    double grams;

    switch (inputUnit) {
      case 'grams':
        grams = quantity;
        break;
      case 'items':
        grams = quantity * food.getGramsPerUnit();
        break;
      case 'servings':
        grams = quantity * food.getGramsPerUnit();
        break;
      default:
        grams = quantity;
    }

    return MealIngredient(
      foodId: foodId,
      grams: grams,
      originalQuantity: quantity,
      originalUnit: inputUnit,
    );
  }

  // Display the quantity in a user-friendly way
  String getDisplayQuantity(FoodItem food) {
    if (originalQuantity != null && originalUnit != null) {
      switch (originalUnit!) {
        case 'items':
          return '${originalQuantity!.toStringAsFixed(originalQuantity! % 1 == 0 ? 0 : 1)} ${originalQuantity! == 1 ? 'item' : 'items'}';
        case 'servings':
          if (food.servingDescription != null) {
            return '${originalQuantity!.toStringAsFixed(originalQuantity! % 1 == 0 ? 0 : 1)} ${food.servingDescription!}${originalQuantity! != 1 ? 's' : ''}';
          }
          return '${originalQuantity!.toStringAsFixed(originalQuantity! % 1 == 0 ? 0 : 1)} ${originalQuantity! == 1 ? 'serving' : 'servings'}';
        case 'grams':
        default:
          return '${grams.toStringAsFixed(grams % 1 == 0 ? 0 : 1)}g';
      }
    }
    return '${grams.toStringAsFixed(grams % 1 == 0 ? 0 : 1)}g';
  }

  // Get equivalent quantity in grams for display
  String getGramsDisplay() {
    return '${grams.toStringAsFixed(grams % 1 == 0 ? 0 : 1)}g';
  }

  // Calculate macros for this ingredient
  Map<String, double> calculateMacros(FoodItem food) {
    return food.getMacrosForGrams(grams);
  }
}

@HiveType(typeId: 2)
class Meal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<MealIngredient> ingredients;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime lastUsed;

  @HiveField(6)
  int useCount;

  @HiveField(7)
  String? category; // Optional maybe later: breakfast, lunch, dinner, snack

  @HiveField(8)
  bool isFavorite; // Optional maybe later: mark favorite meals

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.createdAt,
    required this.lastUsed,
    this.useCount = 0,
    this.category,
    this.isFavorite = false,
  });

  // Helper method to get total weight
  double getTotalWeight() {
    return ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.grams);
  }

  // Helper method to get ingredient count
  int getIngredientCount() {
    return ingredients.length;
  }

  // Check if meal is empty
  bool get isEmpty => ingredients.isEmpty;

  // Add ingredient to meal
  void addIngredient(MealIngredient ingredient) {
    ingredients.add(ingredient);
  }

  // Remove ingredient from meal
  void removeIngredient(int index) {
    if (index >= 0 && index < ingredients.length) {
      ingredients.removeAt(index);
    }
  }

  // Update ingredient quantity
  void updateIngredientQuantity(int index, double newGrams) {
    if (index >= 0 && index < ingredients.length) {
      ingredients[index].grams = newGrams;
    }
  }

  // Create a copy of the meal with new name/id
  Meal copyWith({
    String? newId,
    String? newName,
    String? newDescription,
    String? newCategory,
  }) {
    return Meal(
      id: newId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: newName ?? '$name (Copy)',
      description: newDescription ?? description,
      ingredients: ingredients
          .map(
            (ingredient) => MealIngredient(
              foodId: ingredient.foodId,
              grams: ingredient.grams,
              originalQuantity: ingredient.originalQuantity,
              originalUnit: ingredient.originalUnit,
            ),
          )
          .toList(),
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
      useCount: 0,
      category: newCategory ?? category,
      isFavorite: false,
    );
  }
}
