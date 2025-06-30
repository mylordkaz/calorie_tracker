import 'package:hive/hive.dart';
import '../models/food_item.dart';
import '../models/meal.dart';

class FoodDatabaseService {
  static const String _foodBoxName = 'foods';
  static const String _mealBoxName = 'meals';

  static late Box<FoodItem> _foodBox;
  static late Box<Meal> _mealBox;

  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(MealAdapter());
    Hive.registerAdapter(MealIngredientAdapter());

    // Open boxes
    _foodBox = await Hive.openBox<FoodItem>(_foodBoxName);
    _mealBox = await Hive.openBox<Meal>(_mealBoxName);
  }

  // =============================================================================
  // FOOD CRUD OPERATIONS
  // =============================================================================

  static Future<void> addFood(FoodItem food) async {
    await _foodBox.put(food.id, food);
  }

  static FoodItem? getFood(String id) {
    return _foodBox.get(id);
  }

  static List<FoodItem> getAllFoods() {
    return _foodBox.values.toList();
  }

  static Future<void> updateFood(FoodItem food) async {
    await _foodBox.put(food.id, food);
  }

  static Future<void> deleteFood(String id) async {
    await _foodBox.delete(id);
  }

  static List<FoodItem> searchFoods(String query) {
    if (query.isEmpty) return getAllFoods();

    return _foodBox.values
        .where(
          (food) =>
              food.name.toLowerCase().contains(query.toLowerCase()) ||
              food.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  static List<FoodItem> getRecentFoods({int limit = 10}) {
    var foods = _foodBox.values.toList();
    foods.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    return foods.take(limit).toList();
  }

  static List<FoodItem> getMostUsedFoods({int limit = 10}) {
    var foods = _foodBox.values.toList();
    foods.sort((a, b) => b.useCount.compareTo(a.useCount));
    return foods.take(limit).toList();
  }

  static Future<void> markFoodAsUsed(String foodId) async {
    var food = _foodBox.get(foodId);
    if (food != null) {
      food.lastUsed = DateTime.now();
      food.useCount += 1;
      await _foodBox.put(foodId, food);
    }
  }

  // =============================================================================
  // MEAL CRUD OPERATIONS
  // =============================================================================

  static Future<void> addMeal(Meal meal) async {
    await _mealBox.put(meal.id, meal);
  }

  static Meal? getMeal(String id) {
    return _mealBox.get(id);
  }

  static List<Meal> getAllMeals() {
    return _mealBox.values.toList();
  }

  static Future<void> updateMeal(Meal meal) async {
    await _mealBox.put(meal.id, meal);
  }

  static Future<void> deleteMeal(String id) async {
    await _mealBox.delete(id);
  }

  static List<Meal> searchMeals(String query) {
    if (query.isEmpty) return getAllMeals();

    return _mealBox.values
        .where(
          (meal) =>
              meal.name.toLowerCase().contains(query.toLowerCase()) ||
              meal.description.toLowerCase().contains(query.toLowerCase()) ||
              (meal.category?.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList();
  }

  static List<Meal> getRecentMeals({int limit = 10}) {
    var meals = _mealBox.values.toList();
    meals.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    return meals.take(limit).toList();
  }

  static List<Meal> getFavoriteMeals() {
    return _mealBox.values.where((meal) => meal.isFavorite).toList();
  }

  static List<Meal> getMealsByCategory(String category) {
    return _mealBox.values.where((meal) => meal.category == category).toList();
  }

  static Future<void> markMealAsUsed(String mealId) async {
    var meal = _mealBox.get(mealId);
    if (meal != null) {
      meal.lastUsed = DateTime.now();
      meal.useCount += 1;
      await _mealBox.put(mealId, meal);

      // Also mark all food ingredients as used
      for (var ingredient in meal.ingredients) {
        await markFoodAsUsed(ingredient.foodId);
      }
    }
  }

  static Future<void> toggleMealFavorite(String mealId) async {
    var meal = _mealBox.get(mealId);
    if (meal != null) {
      meal.isFavorite = !meal.isFavorite;
      await _mealBox.put(mealId, meal);
    }
  }

  // =============================================================================
  // MEAL CALCULATION METHODS
  // =============================================================================

  static Map<String, double> calculateMealMacros(Meal meal) {
    Map<String, double> totalMacros = {
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };

    for (var ingredient in meal.ingredients) {
      var food = getFood(ingredient.foodId);
      if (food != null) {
        var ingredientMacros = food.getMacrosForGrams(ingredient.grams);

        // Add basic macros
        totalMacros['calories'] =
            totalMacros['calories']! + ingredientMacros['calories']!;
        totalMacros['protein'] =
            totalMacros['protein']! + ingredientMacros['protein']!;
        totalMacros['carbs'] =
            totalMacros['carbs']! + ingredientMacros['carbs']!;
        totalMacros['fat'] = totalMacros['fat']! + ingredientMacros['fat']!;

        // Handle custom macros
        ingredientMacros.forEach((key, value) {
          if (!['calories', 'protein', 'carbs', 'fat'].contains(key)) {
            totalMacros[key] = (totalMacros[key] ?? 0) + value;
          }
        });
      }
    }

    return totalMacros;
  }

  static Map<String, double> calculateMealMacrosForQuantity(
    Meal meal,
    double multiplier,
  ) {
    var baseMacros = calculateMealMacros(meal);
    Map<String, double> scaledMacros = {};

    baseMacros.forEach((key, value) {
      scaledMacros[key] = value * multiplier;
    });

    return scaledMacros;
  }

  // Calculate macros per 100g of the meal (useful for meal comparisons)
  static Map<String, double> calculateMealMacrosPer100g(Meal meal) {
    var totalMacros = calculateMealMacros(meal);
    var totalWeight = meal.getTotalWeight();

    if (totalWeight == 0) return totalMacros;

    Map<String, double> macroPer100g = {};
    totalMacros.forEach((key, value) {
      macroPer100g[key] = (value * 100) / totalWeight;
    });

    return macroPer100g;
  }

  // =============================================================================
  // MEAL BUILDER HELPER METHODS
  // =============================================================================

  static Future<Meal> createMealFromIngredients({
    required String name,
    required String description,
    required List<MealIngredient> ingredients,
    String? category,
  }) async {
    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      ingredients: ingredients,
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
      category: category,
    );

    await addMeal(meal);
    return meal;
  }

  static MealIngredient createIngredientFromFood({
    required FoodItem food,
    required double quantity,
    required String unit, // 'grams', 'items', 'servings'
  }) {
    return MealIngredient.fromQuantity(
      foodId: food.id,
      food: food,
      quantity: quantity,
      inputUnit: unit,
    );
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  static List<String> getMealCategories() {
    var categories = _mealBox.values
        .where((meal) => meal.category != null)
        .map((meal) => meal.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  static int getTotalFoodCount() {
    return _foodBox.length;
  }

  static int getTotalMealCount() {
    return _mealBox.length;
  }

  static Future<void> clearAllData() async {
    await _foodBox.clear();
    await _mealBox.clear();
  }

  // Get foods that are missing (referenced in meals but don't exist)
  static List<String> getMissingFoodIds() {
    var allFoodIds = _foodBox.keys.toSet();
    var referencedFoodIds = <String>{};

    for (var meal in _mealBox.values) {
      for (var ingredient in meal.ingredients) {
        referencedFoodIds.add(ingredient.foodId);
      }
    }

    return referencedFoodIds.difference(allFoodIds).toList();
  }

  // Clean up meals that reference deleted foods
  static Future<void> cleanupMeals() async {
    var validFoodIds = _foodBox.keys.toSet();
    var mealsToUpdate = <Meal>[];

    for (var meal in _mealBox.values) {
      var validIngredients = meal.ingredients
          .where((ingredient) => validFoodIds.contains(ingredient.foodId))
          .toList();

      if (validIngredients.length != meal.ingredients.length) {
        meal.ingredients = validIngredients;
        mealsToUpdate.add(meal);
      }
    }

    for (var meal in mealsToUpdate) {
      await updateMeal(meal);
    }
  }
}
