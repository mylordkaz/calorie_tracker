import '../models/daily_entry.dart';
import '../services/daily_tracking_service.dart';
import 'tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  @override
  Future<void> addFoodEntry({
    required String foodId,
    required double grams,
    double? originalQuantity,
    String? originalUnit,
  }) async {
    return DailyTrackingService.addFoodEntry(
      foodId: foodId,
      grams: grams,
      originalQuantity: originalQuantity,
      originalUnit: originalUnit,
    );
  }

  @override
  Future<void> addFoodEntryForDate({
    required String foodId,
    required double grams,
    required DateTime date,
    double? originalQuantity,
    String? originalUnit,
  }) async {
    return DailyTrackingService.addFoodEntryForDate(
      foodId: foodId,
      grams: grams,
      date: date,
      originalQuantity: originalQuantity,
      originalUnit: originalUnit,
    );
  }

  @override
  Future<void> addQuickFoodEntry({
    required String name,
    required double calories,
    double protein = 0.0,
    double carbs = 0.0,
    double fat = 0.0,
  }) async {
    return DailyTrackingService.addQuickFoodEntry(
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }

  @override
  Future<void> addQuickFoodEntryForDate({
    required String name,
    required double calories,
    required DateTime date,
    double protein = 0.0,
    double carbs = 0.0,
    double fat = 0.0,
  }) async {
    return DailyTrackingService.addQuickFoodEntryForDate(
      name: name,
      calories: calories,
      date: date,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }

  @override
  Future<void> deleteFoodEntry(String entryId) async {
    return DailyTrackingService.deleteFoodEntry(entryId);
  }

  @override
  Future<void> addMealEntry({
    required String mealId,
    required double multiplier,
  }) async {
    return DailyTrackingService.addMealEntry(
      mealId: mealId,
      multiplier: multiplier,
    );
  }

  @override
  Future<void> addMealEntryForDate({
    required String mealId,
    required double multiplier,
    required DateTime date,
  }) async {
    return DailyTrackingService.addMealEntryForDate(
      mealId: mealId,
      multiplier: multiplier,
      date: date,
    );
  }

  @override
  Future<void> deleteMealEntry(String entryId) async {
    return DailyTrackingService.deleteMealEntry(entryId);
  }

  @override
  List<DailyFoodEntry> getTodayFoodEntries() {
    return DailyTrackingService.getTodayFoodEntries();
  }

  @override
  List<DailyMealEntry> getTodayMealEntries() {
    return DailyTrackingService.getTodayMealEntries();
  }

  @override
  List<DailyFoodEntry> getFoodEntriesForDate(DateTime date) {
    return DailyTrackingService.getFoodEntriesForDate(date);
  }

  @override
  List<DailyMealEntry> getMealEntriesForDate(DateTime date) {
    return DailyTrackingService.getMealEntriesForDate(date);
  }

  @override
  List<DailyFoodEntry> getYesterdayFoodEntries() {
    return DailyTrackingService.getYesterdayFoodEntries();
  }

  @override
  List<DailyMealEntry> getYesterdayMealEntries() {
    return DailyTrackingService.getYesterdayMealEntries();
  }

  @override
  double getTodayCalories() {
    return DailyTrackingService.getTodayCalories();
  }

  @override
  double getCaloriesForDate(DateTime date) {
    return DailyTrackingService.getCaloriesForDate(date);
  }

  @override
  double getWeeklyAverageCalories() {
    return DailyTrackingService.getWeeklyAverageCalories();
  }

  @override
  double getYesterdayCalories() {
    return DailyTrackingService.getYesterdayCalories();
  }

  @override
  Map<String, double> getMacrosForDate(DateTime date) {
    return DailyTrackingService.getMacrosForDate(date);
  }

  @override
  List<Map<String, dynamic>> getCurrentWeekData() {
    return DailyTrackingService.getCurrentWeekData();
  }

  @override
  List<Map<String, dynamic>> getLastNDaysData(int days) {
    return DailyTrackingService.getLastNDaysData(days);
  }

  @override
  double calculateAverage(List<Map<String, dynamic>> data, String macroType) {
    return DailyTrackingService.calculateAverage(data, macroType);
  }

  @override
  bool hasEntriesForDate(DateTime date) {
    return DailyTrackingService.hasEntriesForDate(date);
  }

  @override
  List<DateTime> getDatesWithEntriesForMonth(int year, int month) {
    return DailyTrackingService.getDatesWithEntriesForMonth(year, month);
  }
}
