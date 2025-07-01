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
      if (!entry.timestamp.isBefore(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final food = FoodDatabaseService.getFood(entry.foodId);
        if (food != null) {
          totalCalories += food.getCaloriesForGrams(entry.grams);
        }
      }
    }

    // Calculate calories from meal entries
    for (var entry in _mealEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfDay) &&
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
      if (!entry.timestamp.isBefore(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final food = FoodDatabaseService.getFood(entry.foodId);
        if (food != null) {
          totalCalories += food.getCaloriesForGrams(entry.grams);
        }
      }
    }

    // Calculate calories from meal entries
    for (var entry in _mealEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfDay) &&
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
              !entry.timestamp.isBefore(startOfDay) &&
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
              !entry.timestamp.isBefore(startOfDay) &&
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

  // Get food entries for a specific date
  static List<DailyFoodEntry> getFoodEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return _foodEntriesBox.values
        .where(
          (entry) =>
              !entry.timestamp.isBefore(startOfDay) &&
              entry.timestamp.isBefore(endOfDay),
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Get meal entries for a specific date
  static List<DailyMealEntry> getMealEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return _mealEntriesBox.values
        .where(
          (entry) =>
              !entry.timestamp.isBefore(startOfDay) &&
              entry.timestamp.isBefore(endOfDay),
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Get yesterday's entries
  static List<DailyFoodEntry> getYesterdayFoodEntries() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return getFoodEntriesForDate(yesterday);
  }

  static List<DailyMealEntry> getYesterdayMealEntries() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return getMealEntriesForDate(yesterday);
  }

  // Get macros for a specific date
  static Map<String, double> getMacrosForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    Map<String, double> totalMacros = {
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };

    // Calculate macros from food entries
    for (var entry in _foodEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final food = FoodDatabaseService.getFood(entry.foodId);
        if (food != null) {
          final macros = food.getMacrosForGrams(entry.grams);
          totalMacros['calories'] =
              totalMacros['calories']! + macros['calories']!;
          totalMacros['protein'] = totalMacros['protein']! + macros['protein']!;
          totalMacros['carbs'] = totalMacros['carbs']! + macros['carbs']!;
          totalMacros['fat'] = totalMacros['fat']! + macros['fat']!;
        }
      }
    }

    // Calculate macros from meal entries
    for (var entry in _mealEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        final meal = FoodDatabaseService.getMeal(entry.mealId);
        if (meal != null) {
          final mealMacros = FoodDatabaseService.calculateMealMacros(meal);
          totalMacros['calories'] =
              totalMacros['calories']! +
              (mealMacros['calories'] ?? 0.0) * entry.multiplier;
          totalMacros['protein'] =
              totalMacros['protein']! +
              (mealMacros['protein'] ?? 0.0) * entry.multiplier;
          totalMacros['carbs'] =
              totalMacros['carbs']! +
              (mealMacros['carbs'] ?? 0.0) * entry.multiplier;
          totalMacros['fat'] =
              totalMacros['fat']! +
              (mealMacros['fat'] ?? 0.0) * entry.multiplier;
        }
      }
    }

    return totalMacros;
  }

  // Get data for current week (Monday to Sunday)
  static List<Map<String, dynamic>> getCurrentWeekData() {
    final now = DateTime.now();
    final mondayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<Map<String, dynamic>> weekData = [];

    for (int i = 0; i < 7; i++) {
      final date = mondayOfWeek.add(Duration(days: i));
      final macros = getMacrosForDate(date);
      weekData.add({'date': date, 'macros': macros});
    }

    return weekData;
  }

  // Get data for last N days
  static List<Map<String, dynamic>> getLastNDaysData(int days) {
    final now = DateTime.now();
    List<Map<String, dynamic>> data = [];

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final macros = getMacrosForDate(date);
      data.add({'date': date, 'macros': macros});
    }

    return data;
  }

  // Calculate average for a dataset
  static double calculateAverage(
    List<Map<String, dynamic>> data,
    String macroType,
  ) {
    if (data.isEmpty) return 0.0;

    double total = 0.0;
    int validDays = 0;

    for (var dayData in data) {
      final value = dayData['macros'][macroType] as double;
      if (value > 0) {
        total += value;
        validDays++;
      }
    }

    return validDays > 0 ? total / validDays : 0.0;
  }

  // Check if a date has any entries
  static bool hasEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    // Check food entries
    for (var entry in _foodEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        return true;
      }
    }

    // Check meal entries
    for (var entry in _mealEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfDay) &&
          entry.timestamp.isBefore(endOfDay)) {
        return true;
      }
    }

    return false;
  }

  // Get all dates with entries for a specific month
  static List<DateTime> getDatesWithEntriesForMonth(int year, int month) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1);

    Set<DateTime> datesWithEntries = <DateTime>{};

    // Check food entries
    for (var entry in _foodEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfMonth) &&
          entry.timestamp.isBefore(endOfMonth)) {
        final dateOnly = DateTime(
          entry.timestamp.year,
          entry.timestamp.month,
          entry.timestamp.day,
        );
        datesWithEntries.add(dateOnly);
      }
    }

    // Check meal entries
    for (var entry in _mealEntriesBox.values) {
      if (!entry.timestamp.isBefore(startOfMonth) &&
          entry.timestamp.isBefore(endOfMonth)) {
        final dateOnly = DateTime(
          entry.timestamp.year,
          entry.timestamp.month,
          entry.timestamp.day,
        );
        datesWithEntries.add(dateOnly);
      }
    }

    return datesWithEntries.toList();
  }

  // Add these methods to DailyTrackingService class

  // Add food entry for a specific date
  static Future<void> addFoodEntryForDate({
    required String foodId,
    required double grams,
    required DateTime date,
    double? originalQuantity,
    String? originalUnit,
  }) async {
    final entry = DailyFoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodId: foodId,
      grams: grams,
      timestamp: DateTime(
        date.year,
        date.month,
        date.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      ),
      originalQuantity: originalQuantity,
      originalUnit: originalUnit,
    );

    await _foodEntriesBox.put(entry.id, entry);
    await FoodDatabaseService.markFoodAsUsed(foodId);
  }

  // Add meal entry for a specific date
  static Future<void> addMealEntryForDate({
    required String mealId,
    required double multiplier,
    required DateTime date,
  }) async {
    final entry = DailyMealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mealId: mealId,
      multiplier: multiplier,
      timestamp: DateTime(
        date.year,
        date.month,
        date.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      ),
    );

    await _mealEntriesBox.put(entry.id, entry);
    await FoodDatabaseService.markMealAsUsed(mealId);
  }
}
