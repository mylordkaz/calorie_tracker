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

  @override
  List<FoodItem> getRecentFoods({int limit = 10}) {
    return FoodDatabaseService.getRecentFoods(limit: limit);
  }

  @override
  List<FoodItem> getMostUsedFoods({int limit = 10}) {
    return FoodDatabaseService.getMostUsedFoods(limit: limit);
  }

  @override
  List<Meal> getRecentMeals({int limit = 10}) {
    return FoodDatabaseService.getRecentMeals(limit: limit);
  }

  @override
  List<Meal> getFavoriteMeals() {
    return FoodDatabaseService.getFavoriteMeals();
  }

  @override
  List<Meal> getMealsByCategory(String category) {
    return FoodDatabaseService.getMealsByCategory(category);
  }

  @override
  Future<void> toggleMealFavorite(String mealId) async {
    return FoodDatabaseService.toggleMealFavorite(mealId);
  }

  @override
  Map<String, double> calculateMealMacrosForQuantity(
    Meal meal,
    double multiplier,
  ) {
    return FoodDatabaseService.calculateMealMacrosForQuantity(meal, multiplier);
  }

  @override
  Map<String, double> calculateMealMacrosPer100g(Meal meal) {
    return FoodDatabaseService.calculateMealMacrosPer100g(meal);
  }

  @override
  Future<Meal> createMealFromIngredients({
    required String name,
    required String description,
    required List<MealIngredient> ingredients,
    String? category,
  }) async {
    return FoodDatabaseService.createMealFromIngredients(
      name: name,
      description: description,
      ingredients: ingredients,
      category: category,
    );
  }

  @override
  MealIngredient createIngredientFromFood({
    required FoodItem food,
    required double quantity,
    required String unit,
  }) {
    return FoodDatabaseService.createIngredientFromFood(
      food: food,
      quantity: quantity,
      unit: unit,
    );
  }

  @override
  List<String> getMealCategories() {
    return FoodDatabaseService.getMealCategories();
  }

  @override
  int getTotalFoodCount() {
    return FoodDatabaseService.getTotalFoodCount();
  }

  @override
  int getTotalMealCount() {
    return FoodDatabaseService.getTotalMealCount();
  }

  @override
  Future<void> clearAllData() async {
    return FoodDatabaseService.clearAllData();
  }

  @override
  List<String> getMissingFoodIds() {
    return FoodDatabaseService.getMissingFoodIds();
  }

  @override
  Future<void> cleanupMeals() async {
    return FoodDatabaseService.cleanupMeals();
  }
}
