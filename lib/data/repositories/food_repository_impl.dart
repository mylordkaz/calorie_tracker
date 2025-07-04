import '../models/food_item.dart';
import '../models/meal.dart';
import '../services/food_database_service.dart';
import 'food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  @override
  Future<void> addFood(FoodItem food) async {
    return FoodDatabaseService.addFood(food);
  }

  @override
  FoodItem? getFood(String id) {
    return FoodDatabaseService.getFood(id);
  }

  @override
  List<FoodItem> getAllFoods() {
    return FoodDatabaseService.getAllFoods();
  }

  @override
  Future<void> updateFood(FoodItem food) async {
    return FoodDatabaseService.updateFood(food);
  }

  @override
  Future<void> deleteFood(String id) async {
    return FoodDatabaseService.deleteFood(id);
  }

  @override
  List<FoodItem> searchFoods(String query) {
    return FoodDatabaseService.searchFoods(query);
  }

  @override
  Future<void> markFoodAsUsed(String foodId) async {
    return FoodDatabaseService.markFoodAsUsed(foodId);
  }

  @override
  Future<void> addMeal(Meal meal) async {
    return FoodDatabaseService.addMeal(meal);
  }

  @override
  Meal? getMeal(String id) {
    return FoodDatabaseService.getMeal(id);
  }

  @override
  List<Meal> getAllMeals() {
    return FoodDatabaseService.getAllMeals();
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    return FoodDatabaseService.updateMeal(meal);
  }

  @override
  Future<void> deleteMeal(String id) async {
    return FoodDatabaseService.deleteMeal(id);
  }

  @override
  List<Meal> searchMeals(String query) {
    return FoodDatabaseService.searchMeals(query);
  }

  @override
  Future<void> markMealAsUsed(String mealId) async {
    return FoodDatabaseService.markMealAsUsed(mealId);
  }

  @override
  Map<String, double> calculateMealMacros(Meal meal) {
    return FoodDatabaseService.calculateMealMacros(meal);
  }
}
