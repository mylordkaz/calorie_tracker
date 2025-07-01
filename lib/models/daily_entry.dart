import 'package:hive/hive.dart';

part 'daily_entry.g.dart';

@HiveType(typeId: 4)
class DailyFoodEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String foodId;

  @HiveField(2)
  double grams;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String? mealId; // If this entry is from a meal

  @HiveField(5)
  double? originalQuantity;

  @HiveField(6)
  String? originalUnit;

  DailyFoodEntry({
    required this.id,
    required this.foodId,
    required this.grams,
    required this.timestamp,
    this.mealId,
    this.originalQuantity,
    this.originalUnit,
  });
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
