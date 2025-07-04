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

  // Meal operations
  Future<void> addMeal(Meal meal);
  Meal? getMeal(String id);
  List<Meal> getAllMeals();
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
  List<Meal> searchMeals(String query);
  Future<void> markMealAsUsed(String mealId);

  // Meal calculations
  Map<String, double> calculateMealMacros(Meal meal);
}
