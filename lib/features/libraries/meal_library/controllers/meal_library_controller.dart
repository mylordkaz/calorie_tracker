import 'package:flutter/material.dart';
import '../../../../data/repositories/food_repository.dart';
import '../../../../data/models/meal.dart';

class MealLibraryController extends ChangeNotifier {
  final FoodRepository _foodRepository;

  MealLibraryController({required FoodRepository foodRepository})
    : _foodRepository = foodRepository;

  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  String _searchQuery = '';
  bool _isLoading = true;

  // Getters
  List<Meal> get meals => _meals;
  List<Meal> get filteredMeals => _filteredMeals;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isEmpty => _meals.isEmpty;
  bool get hasSearchResults =>
      _filteredMeals.isNotEmpty || _searchQuery.isEmpty;

  // Initialize and load data
  Future<void> loadMeals() async {
    try {
      _isLoading = true;
      notifyListeners();

      _meals = _foodRepository.getAllMeals();
      _filteredMeals = _meals;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading meals: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search functionality
  void onSearchChanged(String query) {
    _searchQuery = query;
    _filteredMeals = _foodRepository.searchMeals(query);
    notifyListeners();
  }

  // Delete meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _foodRepository.deleteMeal(mealId);
      await loadMeals(); // Refresh the list
    } catch (e) {
      print('Error deleting meal: $e');
      rethrow;
    }
  }

  // Toggle favorite
  Future<void> toggleMealFavorite(String mealId) async {
    try {
      await _foodRepository.toggleMealFavorite(mealId);
      await loadMeals(); // Refresh the list
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await loadMeals();
  }

  // Get meal by ID
  Meal? getMeal(String id) {
    return _foodRepository.getMeal(id);
  }

  // Calculate meal macros
  Map<String, double> calculateMealMacros(Meal meal) {
    return _foodRepository.calculateMealMacros(meal);
  }

  // Get total count
  int getTotalMealCount() {
    return _foodRepository.getTotalMealCount();
  }

  // Get meal categories
  List<String> getMealCategories() {
    return _foodRepository.getMealCategories();
  }
}
