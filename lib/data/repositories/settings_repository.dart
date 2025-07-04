import '../models/user_settings.dart';

abstract class SettingsRepository {
  // Basic settings operations
  UserSettings getSettings();
  Future<void> saveSettings(UserSettings settings);

  // Calorie target
  double? getDailyCalorieTarget();
  Future<void> setDailyCalorieTarget(double? target);

  // Profile operations
  Future<void> updateProfile({
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    double? neck,
    double? waist,
    double? hip,
  });

  // App preferences
  Future<void> updateAppPreferences({bool? darkMode, bool? notifications});

  // Helper checks
  bool get hasBasicProfile;
  bool get hasCustomCalorieTarget;
  bool get isInitialized;
}
