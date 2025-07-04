import '../models/food_item.dart';
import '../models/meal.dart';

abstract class FoodRepository {
  // Food operations
  Future<void> addFood(FoodItem food);
  FoodItem? getFood(String id);
  List<FoodItem> getAllFoods();
  Future<void> updateFood(FoodItem food);
  Future<void> deleteFood(String id);
  List<FoodItem> searchFoods(String query);
  Future<void> markFoodAsUsed(String foodId);
  int getTotalFoodCount();
  List<String> getMissingFoodIds();

  // Meal operations
  Future<void> addMeal(Meal meal);
  Meal? getMeal(String id);
  List<Meal> getAllMeals();
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
  List<Meal> searchMeals(String query);
  Future<void> markMealAsUsed(String mealId);
  Future<void> toggleMealFavorite(String mealId);
  Future<Meal> createMealFromIngredients({
    required String name,
    required String description,
    required List<MealIngredient> ingredients,
    String? category,
  });
  MealIngredient createIngredientFromFood({
    required FoodItem food,
    required double quantity,
    required String unit,
  });
  List<String> getMealCategories();
  int getTotalMealCount();
  Future<void> cleanupMeals();

  // Meal calculations
  Map<String, double> calculateMealMacros(Meal meal);
  Map<String, double> calculateMealMacrosForQuantity(
    Meal meal,
    double multiplier,
  );
  Map<String, double> calculateMealMacrosPer100g(Meal meal);

  Future<void> clearAllData();
}
