import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 3)
class UserSettings extends HiveObject {
  @HiveField(0)
  double? dailyCalorieTarget;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  DateTime lastUpdated;

  @HiveField(3)
  double? weight; // in kg

  @HiveField(4)
  double? height; // in cm

  @HiveField(5)
  int? age;

  @HiveField(6)
  String? gender; // 'male', 'female'

  @HiveField(7)
  String? activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'

  @HiveField(8)
  double? neck;

  @HiveField(9)
  double? waist;

  @HiveField(10)
  double? hip;

  @HiveField(11)
  bool darkMode;

  @HiveField(12)
  bool notifications;

  UserSettings({
    this.dailyCalorieTarget,
    required this.createdAt,
    required this.lastUpdated,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.activityLevel,
    this.neck,
    this.waist,
    this.hip,
    this.darkMode = false,
    this.notifications = true,
  });

  // Create default settings
  factory UserSettings.defaultSettings() {
    final now = DateTime.now();
    return UserSettings(
      dailyCalorieTarget: null,
      createdAt: now,
      lastUpdated: now,
      darkMode: false,
      notifications: true,
    );
  }

  // Helper method to update last modified
  void touch() {
    lastUpdated = DateTime.now();
  }
}
