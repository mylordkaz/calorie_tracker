import 'package:hive/hive.dart';

part 'daily_entry.g.dart';

@HiveType(typeId: 4)
class DailyFoodEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? foodId;

  @HiveField(2)
  double grams;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String? mealId;

  @HiveField(5)
  double? originalQuantity;

  @HiveField(6)
  String? originalUnit;

  @HiveField(7)
  String? quickEntryName;

  @HiveField(8)
  double? quickEntryCalories;

  @HiveField(9)
  double? quickEntryProtein;

  @HiveField(10)
  double? quickEntryCarbs;

  @HiveField(11)
  double? quickEntryFat;

  DailyFoodEntry({
    required this.id,
    this.foodId,
    required this.grams,
    required this.timestamp,
    this.mealId,
    this.originalQuantity,
    this.originalUnit,
    this.quickEntryName,
    this.quickEntryCalories,
    this.quickEntryProtein,
    this.quickEntryCarbs,
    this.quickEntryFat,
  });

  bool get isQuickEntry => foodId == null && quickEntryName != null;

  String getDisplayName() {
    if (isQuickEntry) {
      return quickEntryName!;
    }
    return '';
  }

  double getCalories() {
    if (isQuickEntry) {
      return quickEntryCalories ?? 0.0;
    }

    return 0.0;
  }

  Map<String, double> getMacros() {
    if (isQuickEntry) {
      return {
        'calories': quickEntryCalories ?? 0.0,
        'protein': quickEntryProtein ?? 0.0,
        'carbs': quickEntryCarbs ?? 0.0,
        'fat': quickEntryFat ?? 0.0,
      };
    }
    return {'calories': 0.0, 'protein': 0.0, 'carbs': 0.0, 'fat': 0.0};
  }
}

@HiveType(typeId: 5)
class DailyMealEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String mealId;

  @HiveField(2)
  double multiplier; // How many servings/portions

  @HiveField(3)
  DateTime timestamp;

  DailyMealEntry({
    required this.id,
    required this.mealId,
    required this.multiplier,
    required this.timestamp,
  });
}
