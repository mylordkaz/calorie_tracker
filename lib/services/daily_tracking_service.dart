import 'package:hive/hive.dart';
import '../models/daily_entry.dart';
import '../models/food_item.dart';
import '../models/meal.dart';
import 'food_database_service.dart';

class DailyTrackingService {
  static const String _foodEntriesBoxName = 'daily_food_entries';
  static const String _mealEntriesBoxName = 'daily_meal_entries';

  static late Box<DailyFoodEntry> _foodEntriesBox;
  static late Box<DailyMealEntry> _mealEntriesBox;

  static Future<void> init() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(DailyFoodEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(DailyMealEntryAdapter());
    }

    // Open boxes
    _foodEntriesBox = await Hive.openBox<DailyFoodEntry>(_foodEntriesBoxName);
    _mealEntriesBox = await Hive.openBox<DailyMealEntry>(_mealEntriesBoxName);
  }

  // Add food entry
  static Future<void> addFoodEntry({
    required String foodId,
    required double grams,
    double? originalQuantity,
    String? originalUnit,
  }) async {
    final entry = DailyFoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodId: foodId,
      grams: grams,
      timestamp: DateTime.now(),
      originalQuantity: originalQuantity,
      originalUnit: originalUnit,
    );

    await _foodEntriesBox.put(entry.id, entry);

    // Mark food as used
    await FoodDatabaseService.markFoodAsUsed(foodId);
  }

  // Add meal entry
  static Future<void> addMealEntry({
    required String mealId,
    required double multiplier,
  }) async {
    final entry = DailyMealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mealId: mealId,
      multiplier: multiplier,
      timestamp: DateTime.now(),
    );

    await _mealEntriesBox.put(entry.id, entry);

    // Mark meal as used
    await FoodDatabaseService.markMealAsUsed(mealId);
  }

  // Get today's total calories
  static double getTodayCalories() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    double totalCalories = 0.0;

    // Calculate calories from food entries
    for (var entry in _foodEntriesBox.values) {
      if (entry.timestamp.isAfter(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final food = FoodDatabaseService.getFood(entry.foodId);
        if (food != null) {
          totalCalories += food.getCaloriesForGrams(entry.grams);
        }
      }
    }

    // Calculate calories from meal entries
    for (var entry in _mealEntriesBox.values) {
      if (entry.timestamp.isAfter(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final meal = FoodDatabaseService.getMeal(entry.mealId);
        if (meal != null) {
          final mealMacros = FoodDatabaseService.calculateMealMacros(meal);
          totalCalories += (mealMacros['calories'] ?? 0.0) * entry.multiplier;
        }
      }
    }

    return totalCalories;
  }

  // Get calories for a specific date
  static double getCaloriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    double totalCalories = 0.0;

    // Calculate calories from food entries
    for (var entry in _foodEntriesBox.values) {
      if (entry.timestamp.isAfter(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final food = FoodDatabaseService.getFood(entry.foodId);
        if (food != null) {
          totalCalories += food.getCaloriesForGrams(entry.grams);
        }
      }
    }

    // Calculate calories from meal entries
    for (var entry in _mealEntriesBox.values) {
      if (entry.timestamp.isAfter(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final meal = FoodDatabaseService.getMeal(entry.mealId);
        if (meal != null) {
          final mealMacros = FoodDatabaseService.calculateMealMacros(meal);
          totalCalories += (mealMacros['calories'] ?? 0.0) * entry.multiplier;
        }
      }
    }

    return totalCalories;
  }

  // Get today's entries
  static List<DailyFoodEntry> getTodayFoodEntries() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return _foodEntriesBox.values
        .where(
          (entry) =>
              entry.timestamp.isAfter(startOfDay) &&
              entry.timestamp.isBefore(endOfDay),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static List<DailyMealEntry> getTodayMealEntries() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return _mealEntriesBox.values
        .where(
          (entry) =>
              entry.timestamp.isAfter(startOfDay) &&
              entry.timestamp.isBefore(endOfDay),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Delete entry
  static Future<void> deleteFoodEntry(String entryId) async {
    await _foodEntriesBox.delete(entryId);
  }

  static Future<void> deleteMealEntry(String entryId) async {
    await _mealEntriesBox.delete(entryId);
  }

  // Get weekly average
  static double getWeeklyAverageCalories() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: 7));

    double totalCalories = 0.0;
    int daysWithEntries = 0;

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dayCalories = getCaloriesForDate(date);
      if (dayCalories > 0) {
        totalCalories += dayCalories;
        daysWithEntries++;
      }
    }

    return daysWithEntries > 0 ? totalCalories / daysWithEntries : 0.0;
  }

  // Get yesterday's calories
  static double getYesterdayCalories() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return getCaloriesForDate(yesterday);
  }
}
