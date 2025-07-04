import 'package:flutter/material.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../data/repositories/settings_repository.dart';

class HomeController extends ChangeNotifier {
  final FoodRepository _foodRepository;
  final TrackingRepository _trackingRepository;
  final SettingsRepository _settingsRepository;

  HomeController({
    required FoodRepository foodRepository,
    required TrackingRepository trackingRepository,
    required SettingsRepository settingsRepository,
  }) : _foodRepository = foodRepository,
       _trackingRepository = trackingRepository,
       _settingsRepository = settingsRepository;

  // State
  double? _dailyTarget;
  double _currentCalories = 0;
  Map<String, double> _currentMacros = {'protein': 0, 'carbs': 0, 'fat': 0};
  bool _isLoading = true;

  // Getters
  double? get dailyTarget => _dailyTarget;
  double get currentCalories => _currentCalories;
  Map<String, double> get currentMacros => _currentMacros;
  bool get isLoading => _isLoading;

  double get weeklyAverage => _trackingRepository.getWeeklyAverageCalories();
  double get yesterdayCalories => _trackingRepository.getYesterdayCalories();

  // Initialize data
  Future<void> loadData() async {
    try {
      if (_settingsRepository.isInitialized) {
        _dailyTarget = _settingsRepository.getDailyCalorieTarget();
        _currentCalories = _trackingRepository.getTodayCalories();
        _currentMacros = _calculateTodayMacros();
        _isLoading = false;
        notifyListeners();
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        await loadData();
      }
    } catch (e) {
      print('Error loading data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate today's macros
  Map<String, double> _calculateTodayMacros() {
    Map<String, double> totalMacros = {'protein': 0, 'carbs': 0, 'fat': 0};

    // Get today's food entries
    final foodEntries = _trackingRepository.getTodayFoodEntries();
    for (var entry in foodEntries) {
      if (entry.isQuickEntry) {
        final macros = entry.getMacros();
        totalMacros['protein'] = totalMacros['protein']! + macros['protein']!;
        totalMacros['carbs'] = totalMacros['carbs']! + macros['carbs']!;
        totalMacros['fat'] = totalMacros['fat']! + macros['fat']!;
      } else if (entry.foodId != null) {
        final food = _foodRepository.getFood(entry.foodId!);
        if (food != null) {
          final macros = food.getMacrosForGrams(entry.grams);
          totalMacros['protein'] = totalMacros['protein']! + macros['protein']!;
          totalMacros['carbs'] = totalMacros['carbs']! + macros['carbs']!;
          totalMacros['fat'] = totalMacros['fat']! + macros['fat']!;
        }
      }
    }

    // Get today's meal entries
    final mealEntries = _trackingRepository.getTodayMealEntries();
    for (var entry in mealEntries) {
      final meal = _foodRepository.getMeal(entry.mealId);
      if (meal != null) {
        final mealMacros = _foodRepository.calculateMealMacros(meal);
        totalMacros['protein'] =
            totalMacros['protein']! +
            (mealMacros['protein']! * entry.multiplier);
        totalMacros['carbs'] =
            totalMacros['carbs']! + (mealMacros['carbs']! * entry.multiplier);
        totalMacros['fat'] =
            totalMacros['fat']! + (mealMacros['fat']! * entry.multiplier);
      }
    }

    return totalMacros;
  }

  // Get today's entries for display
  List<Map<String, dynamic>> getTodayEntries() {
    final todayFoodEntries = _trackingRepository.getTodayFoodEntries();
    final todayMealEntries = _trackingRepository.getTodayMealEntries();

    List<Map<String, dynamic>> allEntries = [];

    // Process food entries
    for (var entry in todayFoodEntries) {
      double calories;
      String name;
      String subtitle;

      if (entry.isQuickEntry) {
        name = entry.quickEntryName!;
        calories = entry.getCalories();
        subtitle = '${entry.grams.toInt()}g (quick entry)';
      } else if (entry.foodId != null) {
        final food = _foodRepository.getFood(entry.foodId!);
        if (food != null) {
          name = food.name;
          calories = food.getCaloriesForGrams(entry.grams);
          if (entry.originalQuantity != null && entry.originalUnit != null) {
            subtitle =
                '${entry.originalQuantity!.toStringAsFixed(entry.originalQuantity! % 1 == 0 ? 0 : 1)} ${entry.originalUnit}';
          } else {
            subtitle = '${entry.grams.toInt()}g';
          }
        } else {
          continue; // Skip if food not found
        }
      } else {
        continue; // Skip invalid entries
      }

      allEntries.add({
        'type': 'food',
        'name': name,
        'subtitle': subtitle,
        'calories': calories,
        'timestamp': entry.timestamp,
      });
    }

    // Process meal entries
    for (var entry in todayMealEntries) {
      final meal = _foodRepository.getMeal(entry.mealId);
      if (meal != null) {
        final mealMacros = _foodRepository.calculateMealMacros(meal);
        final calories = (mealMacros['calories'] ?? 0.0) * entry.multiplier;
        allEntries.add({
          'type': 'meal',
          'name': meal.name,
          'subtitle':
              '${entry.multiplier.toStringAsFixed(entry.multiplier % 1 == 0 ? 0 : 1)}x serving',
          'calories': calories,
          'timestamp': entry.timestamp,
        });
      }
    }

    // Sort by timestamp (newest first)
    allEntries.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return allEntries;
  }

  // Set daily calorie target
  Future<void> setDailyTarget(double target) async {
    await _settingsRepository.setDailyCalorieTarget(target);
    _dailyTarget = target;
    notifyListeners();
  }

  // Copy from yesterday
  Future<void> copyFromYesterday() async {
    final allFoodEntries = _trackingRepository.getYesterdayFoodEntries();
    final allMealEntries = _trackingRepository.getYesterdayMealEntries();

    if (allFoodEntries.isEmpty && allMealEntries.isEmpty) {
      throw Exception('No entries found for yesterday');
    }

    // Copy food entries
    for (var entry in allFoodEntries) {
      if (entry.isQuickEntry) {
        await _trackingRepository.addQuickFoodEntry(
          name: entry.quickEntryName!,
          calories: entry.quickEntryCalories ?? 0.0,
          protein: entry.quickEntryProtein ?? 0.0,
          carbs: entry.quickEntryCarbs ?? 0.0,
          fat: entry.quickEntryFat ?? 0.0,
        );
      } else if (entry.foodId != null) {
        await _trackingRepository.addFoodEntry(
          foodId: entry.foodId!,
          grams: entry.grams,
          originalQuantity: entry.originalQuantity,
          originalUnit: entry.originalUnit,
        );
      }
    }

    // Copy meal entries
    for (var entry in allMealEntries) {
      await _trackingRepository.addMealEntry(
        mealId: entry.mealId,
        multiplier: entry.multiplier,
      );
    }

    // Refresh data
    await loadData();
  }

  // Refresh data (call after returning from add food screen)
  Future<void> refresh() async {
    await loadData();
  }
}
