import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'food_database_service.dart';
import '../models/food_item.dart';
import '../models/meal.dart';

class ImportService {
  // Import food library from CSV
  static Future<ImportResult> importFoodLibrary() async {
    try {
      // Pick CSV file
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv'],
          allowMultiple: false,
        );
      } catch (e) {
        if (e.toString().contains('MissingPluginException')) {
          return ImportResult(
            success: false,
            message:
                'File picker not available. Please restart the app completely (not hot reload) and try again.',
          );
        }
        return ImportResult(success: false, message: 'File picker error: $e');
      }

      if (result == null || result.files.single.path == null) {
        return ImportResult(success: false, message: 'No file selected');
      }

      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();

      // Parse CSV
      List<List<dynamic>> csvData = const CsvToListConverter().convert(
        csvString,
      );

      if (csvData.isEmpty) {
        return ImportResult(success: false, message: 'Empty CSV file');
      }

      // Validate headers
      final headers = csvData[0].map((e) => e.toString()).toList();
      final expectedHeaders = [
        'Name',
        'Description',
        'Calories_per_100g',
        'Protein_per_100g',
        'Carbs_per_100g',
        'Fat_per_100g',
        'Use_Count',
        'Created_Date',
        'Last_Used',
      ];

      if (!_validateHeaders(headers, expectedHeaders)) {
        return ImportResult(
          success: false,
          message: 'Invalid CSV format. Expected food library export format.',
        );
      }

      // Import foods
      int importedCount = 0;
      int skippedCount = 0;

      for (int i = 1; i < csvData.length; i++) {
        try {
          final row = csvData[i];
          if (row.length < expectedHeaders.length) continue;

          final name = row[0]?.toString() ?? '';
          if (name.isEmpty) continue;

          // Check if food already exists
          final existingFoods = FoodDatabaseService.getAllFoods();
          if (existingFoods.any(
            (food) => food.name.toLowerCase() == name.toLowerCase(),
          )) {
            skippedCount++;
            continue;
          }

          // Create food item
          final food = FoodItem(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
            name: name,
            description: row[1]?.toString() ?? '',
            calories: _parseDouble(row[2]) ?? 0.0,
            protein: _parseDouble(row[3]) ?? 0.0,
            carbs: _parseDouble(row[4]) ?? 0.0,
            fat: _parseDouble(row[5]) ?? 0.0,
            useCount: _parseInt(row[6]) ?? 0,
            createdAt: _parseDate(row[7]) ?? DateTime.now(),
            lastUsed: _parseDate(row[8]) ?? DateTime.now(),
          );

          FoodDatabaseService.addFood(food);
          importedCount++;
        } catch (e) {
          // Skip invalid rows
          skippedCount++;
        }
      }

      return ImportResult(
        success: true,
        message:
            'Imported $importedCount foods${skippedCount > 0 ? ' ($skippedCount skipped)' : ''}',
        importedCount: importedCount,
        skippedCount: skippedCount,
      );
    } catch (e) {
      return ImportResult(success: false, message: 'Failed to import: $e');
    }
  }

  // Import meal library from CSV
  static Future<ImportResult> importMealLibrary() async {
    try {
      // Pick CSV file
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv'],
          allowMultiple: false,
        );
      } catch (e) {
        if (e.toString().contains('MissingPluginException')) {
          return ImportResult(
            success: false,
            message:
                'File picker not available. Please restart the app completely (not hot reload) and try again.',
          );
        }
        return ImportResult(success: false, message: 'File picker error: $e');
      }

      if (result == null || result.files.single.path == null) {
        return ImportResult(success: false, message: 'No file selected');
      }

      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();

      // Parse CSV
      List<List<dynamic>> csvData = const CsvToListConverter().convert(
        csvString,
      );

      if (csvData.isEmpty) {
        return ImportResult(success: false, message: 'Empty CSV file');
      }

      // Validate headers
      final headers = csvData[0].map((e) => e.toString()).toList();
      final expectedHeaders = [
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
      ];

      if (!_validateHeaders(headers, expectedHeaders)) {
        return ImportResult(
          success: false,
          message: 'Invalid CSV format. Expected meal library export format.',
        );
      }

      // Import meals
      int importedCount = 0;
      int skippedCount = 0;

      for (int i = 1; i < csvData.length; i++) {
        try {
          final row = csvData[i];
          if (row.length < expectedHeaders.length) continue;

          final name = row[0]?.toString() ?? '';
          if (name.isEmpty) continue;

          // Check if meal already exists
          final existingMeals = FoodDatabaseService.getAllMeals();
          if (existingMeals.any(
            (meal) => meal.name.toLowerCase() == name.toLowerCase(),
          )) {
            skippedCount++;
            continue;
          }

          // Parse ingredients - this is simplified, real meals need existing foods
          final ingredientsDetail = row[12]?.toString() ?? '';
          final ingredients = _parseIngredients(ingredientsDetail);

          if (ingredients.isEmpty) {
            skippedCount++;
            continue;
          }

          // Create meal item
          final meal = Meal(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
            name: name,
            description: row[1]?.toString() ?? '',
            ingredients: ingredients,
            createdAt: _parseDate(row[11]) ?? DateTime.now(),
            lastUsed: _parseDate(row[11]) ?? DateTime.now(),
            useCount: _parseInt(row[8]) ?? 0,
            category: row[10]?.toString().isEmpty == true
                ? null
                : row[10]?.toString(),
            isFavorite: row[9]?.toString().toLowerCase() == 'true',
          );

          FoodDatabaseService.addMeal(meal);
          importedCount++;
        } catch (e) {
          // Skip invalid rows
          skippedCount++;
        }
      }

      return ImportResult(
        success: true,
        message:
            'Imported $importedCount meals${skippedCount > 0 ? ' ($skippedCount skipped)' : ''}',
        importedCount: importedCount,
        skippedCount: skippedCount,
      );
    } catch (e) {
      return ImportResult(success: false, message: 'Failed to import: $e');
    }
  }

  // Helper methods
  static bool _validateHeaders(List<String> actual, List<String> expected) {
    if (actual.length < expected.length) return false;

    for (int i = 0; i < expected.length; i++) {
      if (actual[i] != expected[i]) return false;
    }
    return true;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  static List<MealIngredient> _parseIngredients(String ingredientsDetail) {
    final ingredients = <MealIngredient>[];

    if (ingredientsDetail.isEmpty) return ingredients;

    // Parse format: "Food1:100g; Food2:50g"
    final parts = ingredientsDetail.split('; ');

    for (final part in parts) {
      final colonIndex = part.lastIndexOf(':');
      if (colonIndex == -1) continue;

      final foodName = part.substring(0, colonIndex).trim();
      final weightStr = part
          .substring(colonIndex + 1)
          .replaceAll('g', '')
          .trim();

      final weight = double.tryParse(weightStr);
      if (weight == null) continue;

      // Find existing food by name
      final foods = FoodDatabaseService.getAllFoods();
      final matchingFoods = foods.where(
        (f) => f.name.toLowerCase() == foodName.toLowerCase(),
      );
      final food = matchingFoods.isNotEmpty ? matchingFoods.first : null;

      if (food != null) {
        ingredients.add(MealIngredient(foodId: food.id, grams: weight));
      }
    }

    return ingredients;
  }
}

class ImportResult {
  final bool success;
  final String message;
  final int importedCount;
  final int skippedCount;

  ImportResult({
    required this.success,
    required this.message,
    this.importedCount = 0,
    this.skippedCount = 0,
  });
}
