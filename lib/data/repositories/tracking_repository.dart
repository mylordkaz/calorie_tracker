import '../models/daily_entry.dart';

abstract class TrackingRepository {
  // Food entries
  Future<void> addFoodEntry({
    required String foodId,
    required double grams,
    double? originalQuantity,
    String? originalUnit,
  });

  Future<void> addFoodEntryForDate({
    required String foodId,
    required double grams,
    required DateTime date,
    double? originalQuantity,
    String? originalUnit,
  });

  Future<void> addQuickFoodEntry({
    required String name,
    required double calories,
    double protein = 0.0,
    double carbs = 0.0,
    double fat = 0.0,
  });

  Future<void> addQuickFoodEntryForDate({
    required String name,
    required double calories,
    required DateTime date,
    double protein = 0.0,
    double carbs = 0.0,
    double fat = 0.0,
  });

  Future<void> deleteFoodEntry(String entryId);

  // Meal entries
  Future<void> addMealEntry({
    required String mealId,
    required double multiplier,
  });

  Future<void> addMealEntryForDate({
    required String mealId,
    required double multiplier,
    required DateTime date,
  });

  Future<void> deleteMealEntry(String entryId);

  // Get entries
  List<DailyFoodEntry> getTodayFoodEntries();
  List<DailyMealEntry> getTodayMealEntries();
  List<DailyFoodEntry> getFoodEntriesForDate(DateTime date);
  List<DailyMealEntry> getMealEntriesForDate(DateTime date);
  List<DailyFoodEntry> getYesterdayFoodEntries();
  List<DailyMealEntry> getYesterdayMealEntries();

  // Calculations
  double getTodayCalories();
  double getCaloriesForDate(DateTime date);
  double getWeeklyAverageCalories();
  double getYesterdayCalories();
  Map<String, double> getMacrosForDate(DateTime date);

  // Data analysis
  List<Map<String, dynamic>> getCurrentWeekData();
  List<Map<String, dynamic>> getLastNDaysData(int days);
  double calculateAverage(List<Map<String, dynamic>> data, String macroType);

  // Calendar helpers
  bool hasEntriesForDate(DateTime date);
  List<DateTime> getDatesWithEntriesForMonth(int year, int month);
}
