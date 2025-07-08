import 'package:flutter/material.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../data/models/food_item.dart';
import '../../../data/models/meal.dart';
import '../../../l10n/app_localizations.dart';

class AddEntryForDateController extends ChangeNotifier {
  final FoodRepository _foodRepository;
  final TrackingRepository _trackingRepository;
  final DateTime selectedDate;

  AddEntryForDateController({
    required FoodRepository foodRepository,
    required TrackingRepository trackingRepository,
    required this.selectedDate,
  }) : _foodRepository = foodRepository,
       _trackingRepository = trackingRepository;

  // Food tab state
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  String _foodSearchQuery = '';

  // Meal tab state
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  String _mealSearchQuery = '';

  // Loading state
  bool _isLoading = true;

  // Getters
  List<FoodItem> get filteredFoods => _filteredFoods;
  List<Meal> get filteredMeals => _filteredMeals;
  bool get isLoading => _isLoading;

  // Initialize data
  Future<void> loadData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _foods = _foodRepository.getAllFoods();
      _filteredFoods = _foods;

      _meals = _foodRepository.getAllMeals();
      _filteredMeals = _meals;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Food search
  void onFoodSearchChanged(String query) {
    _foodSearchQuery = query;
    _filteredFoods = _foodRepository.searchFoods(query);
    notifyListeners();
  }

  // Meal search
  void onMealSearchChanged(String query) {
    _mealSearchQuery = query;
    _filteredMeals = _foodRepository.searchMeals(query);
    notifyListeners();
  }

  // Add food entry
  Future<bool> addFoodEntry({
    required String foodId,
    required double grams,
    double? originalQuantity,
    String? originalUnit,
  }) async {
    try {
      await _trackingRepository.addFoodEntryForDate(
        foodId: foodId,
        grams: grams,
        date: selectedDate,
        originalQuantity: originalQuantity,
        originalUnit: originalUnit,
      );
      return true;
    } catch (e) {
      print('Error adding food entry: $e');
      return false;
    }
  }

  // Add meal entry
  Future<bool> addMealEntry({
    required String mealId,
    required double multiplier,
  }) async {
    try {
      await _trackingRepository.addMealEntryForDate(
        mealId: mealId,
        multiplier: multiplier,
        date: selectedDate,
      );
      return true;
    } catch (e) {
      print('Error adding meal entry: $e');
      return false;
    }
  }

  // Add quick entry
  Future<bool> addQuickEntry({
    required String name,
    required double calories,
    double protein = 0.0,
    double carbs = 0.0,
    double fat = 0.0,
    required bool saveToLibrary,
    required AppLocalizations l10n,
  }) async {
    try {
      if (saveToLibrary) {
        // Save to food library and add regular entry
        final quickFood = FoodItem(
          id: 'quick_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          description: l10n.quickEntry,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          createdAt: DateTime.now(),
          lastUsed: DateTime.now(),
        );

        await _foodRepository.addFood(quickFood);
        await _trackingRepository.addFoodEntryForDate(
          foodId: quickFood.id,
          grams: 100,
          date: selectedDate,
        );
      } else {
        // Add as quick entry for the specific date
        await _trackingRepository.addQuickFoodEntryForDate(
          name: name,
          calories: calories,
          date: selectedDate,
          protein: protein,
          carbs: carbs,
          fat: fat,
        );
      }
      return true;
    } catch (e) {
      print('Error adding quick entry: $e');
      return false;
    }
  }

  // Get food by id
  FoodItem? getFood(String id) {
    return _foodRepository.getFood(id);
  }

  // Get meal by id
  Meal? getMeal(String id) {
    return _foodRepository.getMeal(id);
  }

  // Calculate meal macros
  Map<String, double> calculateMealMacros(Meal meal) {
    return _foodRepository.calculateMealMacros(meal);
  }
}
