import '../models/user_settings.dart';
import '../services/user_settings_service.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  UserSettings getSettings() {
    return UserSettingsService.getSettings();
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    return UserSettingsService.saveSettings(settings);
  }

  @override
  double? getDailyCalorieTarget() {
    return UserSettingsService.getDailyCalorieTarget();
  }

  @override
  Future<void> setDailyCalorieTarget(double? target) async {
    return UserSettingsService.setDailyCalorieTarget(target);
  }

  @override
  Future<void> updateProfile({
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    double? neck,
    double? waist,
    double? hip,
  }) async {
    return UserSettingsService.updateProfile(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      neck: neck,
      waist: waist,
      hip: hip,
    );
  }

  @override
  Future<void> updateAppPreferences({
    bool? darkMode,
    bool? notifications,
  }) async {
    return UserSettingsService.updateAppPreferences(
      darkMode: darkMode,
      notifications: notifications,
    );
  }

  @override
  bool get hasBasicProfile {
    return UserSettingsService.hasBasicProfile;
  }

  @override
  bool get hasCustomCalorieTarget {
    return UserSettingsService.hasCustomCalorieTarget;
  }

  @override
  bool get isInitialized {
    return UserSettingsService.isInitialized;
  }
}
