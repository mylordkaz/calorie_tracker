import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'food_database_service.dart';
import 'daily_tracking_service.dart';

class ExportService {
  // Export food library to CSV
  static Future<void> exportFoodLibrary() async {
    try {
      final foods = FoodDatabaseService.getAllFoods();

      // Create CSV headers
      List<List<dynamic>> csvData = [
        [
          'Name',
          'Description',
          'Calories_per_100g',
          'Protein_per_100g',
          'Carbs_per_100g',
          'Fat_per_100g',
          'Use_Count',
          'Created_Date',
          'Last_Used',
        ],
      ];

      // Add food data rows
      for (var food in foods) {
        csvData.add([
          food.name,
          food.description,
          food.calories,
          food.protein,
          food.carbs,
          food.fat,
          food.useCount,
          food.createdAt.toIso8601String(),
          food.lastUsed.toIso8601String(),
        ]);
      }

      await _saveAndShareCsv(csvData, 'food_library');
    } catch (e) {
      throw Exception('Failed to export food library: $e');
    }
  }

  // Export meal library to CSV
  static Future<void> exportMealLibrary() async {
    try {
      final meals = FoodDatabaseService.getAllMeals();

      List<List<dynamic>> csvData = [
        [
          'Meal_Name',
          'Description',
          'Ingredients_Count',
          'Total_Weight_g',
          'Total_Calories',
          'Total_Protein',
          'Total_Carbs',
          'Total_Fat',
          'Use_Count',
          'Is_Favorite',
          'Category',
          'Created_Date',
          'Ingredients_Detail',
        ],
      ];

      for (var meal in meals) {
        final macros = FoodDatabaseService.calculateMealMacros(meal);

        // Create ingredients detail string
        String ingredientsDetail = meal.ingredients
            .map((ingredient) {
              final food = FoodDatabaseService.getFood(ingredient.foodId);
              return '${food?.name ?? 'Unknown'}:${ingredient.grams}g';
            })
            .join('; ');

        csvData.add([
          meal.name,
          meal.description,
          meal.ingredients.length,
          meal.getTotalWeight(),
          macros['calories']?.toStringAsFixed(1) ?? '0',
          macros['protein']?.toStringAsFixed(1) ?? '0',
          macros['carbs']?.toStringAsFixed(1) ?? '0',
          macros['fat']?.toStringAsFixed(1) ?? '0',
          meal.useCount,
          meal.isFavorite,
          meal.category ?? '',
          meal.createdAt.toIso8601String(),
          ingredientsDetail,
        ]);
      }

      await _saveAndShareCsv(csvData, 'meal_library');
    } catch (e) {
      throw Exception('Failed to export meal library: $e');
    }
  }

  // Export calendar data to CSV (daily totals only)
  static Future<void> exportCalendarData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Default to last 30 days if no dates provided
      endDate ??= DateTime.now();
      startDate ??= endDate.subtract(Duration(days: 30));

      List<List<dynamic>> csvData = [
        ['Date', 'Total_Calories', 'Total_Protein', 'Total_Carbs', 'Total_Fat'],
      ];

      // Get all dates in range
      final allDates = _getDateRange(startDate, endDate);

      for (var date in allDates) {
        // Initialize daily totals
        double totalCalories = 0.0;
        double totalProtein = 0.0;
        double totalCarbs = 0.0;
        double totalFat = 0.0;

        // Get all entries for this date
        final foodEntries = DailyTrackingService.getFoodEntriesForDate(date);
        final mealEntries = DailyTrackingService.getMealEntriesForDate(date);

        // Sum up food entries
        for (var entry in foodEntries) {
          Map<String, double> macros;

          if (entry.isQuickEntry) {
            macros = entry.getMacros();
          } else if (entry.foodId != null) {
            final food = FoodDatabaseService.getFood(entry.foodId!);
            if (food != null) {
              macros = food.getMacrosForGrams(entry.grams);
            } else {
              continue;
            }
          } else {
            continue;
          }

          totalCalories += macros['calories'] ?? 0.0;
          totalProtein += macros['protein'] ?? 0.0;
          totalCarbs += macros['carbs'] ?? 0.0;
          totalFat += macros['fat'] ?? 0.0;
        }

        // Sum up meal entries
        for (var entry in mealEntries) {
          final meal = FoodDatabaseService.getMeal(entry.mealId);
          if (meal != null) {
            final macros = FoodDatabaseService.calculateMealMacrosForQuantity(
              meal,
              entry.multiplier,
            );

            totalCalories += macros['calories'] ?? 0.0;
            totalProtein += macros['protein'] ?? 0.0;
            totalCarbs += macros['carbs'] ?? 0.0;
            totalFat += macros['fat'] ?? 0.0;
          }
        }

        // Add daily total row
        csvData.add([
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          totalCalories.toStringAsFixed(1),
          totalProtein.toStringAsFixed(1),
          totalCarbs.toStringAsFixed(1),
          totalFat.toStringAsFixed(1),
        ]);
      }

      await _saveAndShareCsv(csvData, 'calendar_data');
    } catch (e) {
      throw Exception('Failed to export calendar data: $e');
    }
  }

  // Helper method to share CSV file without extra text files
  static Future<void> _saveAndShareCsv(
    List<List<dynamic>> csvData,
    String filename,
  ) async {
    try {
      // Convert to CSV string
      String csvString = const ListToCsvConverter().convert(csvData);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/${filename}_$timestamp.csv');

      // Write CSV file
      await file.writeAsString(csvString);

      // Share only the CSV file
      await Share.shareXFiles([XFile(file.path)]);

      // Clean up temporary file after sharing
      Future.delayed(Duration(seconds: 5), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      throw Exception('Failed to share CSV: $e');
    }
  }

  // Helper to get date range
  static List<DateTime> _getDateRange(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (!current.isAfter(endDate)) {
      dates.add(current);
      current = current.add(Duration(days: 1));
    }

    return dates;
  }
}
