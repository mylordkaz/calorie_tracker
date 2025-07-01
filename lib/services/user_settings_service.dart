import 'package:hive/hive.dart';
import '../models/user_settings.dart';

class UserSettingsService {
  static const String _settingsBoxName = 'user_settings';
  static const String _settingsKey = 'user_settings_data';

  static Box<UserSettings>? _settingsBox;

  static Future<void> init() async {
    // Register the UserSettings adapter here
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }

    try {
      _settingsBox = await Hive.openBox<UserSettings>(_settingsBoxName);
    } catch (e) {
      // If there's an error opening the box (schema mismatch), delete it and recreate
      print('Error opening settings box, clearing data: $e');
      await Hive.deleteBoxFromDisk(_settingsBoxName);
      _settingsBox = await Hive.openBox<UserSettings>(_settingsBoxName);
    }
  }

  static Box<UserSettings> get _box {
    if (_settingsBox == null) {
      throw Exception(
        'UserSettingsService not initialized. Call init() first.',
      );
    }
    return _settingsBox!;
  }

  // Get current settings (create default if none exist)
  static UserSettings getSettings() {
    UserSettings? settings = _box.get(_settingsKey);
    if (settings == null) {
      settings = UserSettings.defaultSettings();
      _box.put(_settingsKey, settings);
    }
    return settings;
  }

  // Save settings
  static Future<void> saveSettings(UserSettings settings) async {
    settings.touch(); // Update lastUpdated
    await _box.put(_settingsKey, settings);
  }

  // Convenience methods for specific settings
  static double? getDailyCalorieTarget() {
    return getSettings().dailyCalorieTarget;
  }

  static Future<void> setDailyCalorieTarget(double? target) async {
    final settings = getSettings();
    settings.dailyCalorieTarget = target;
    await saveSettings(settings);
  }

  static Future<void> updateProfile({
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    String? goal,
  }) async {
    final settings = getSettings();

    if (weight != null) settings.weight = weight;
    if (height != null) settings.height = height;
    if (age != null) settings.age = age;
    if (gender != null) settings.gender = gender;
    if (activityLevel != null) settings.activityLevel = activityLevel;
    if (goal != null) settings.goal = goal;

    await saveSettings(settings);
  }

  static Future<void> updateAppPreferences({
    bool? darkMode,
    bool? notifications,
  }) async {
    final settings = getSettings();

    if (darkMode != null) settings.darkMode = darkMode;
    if (notifications != null) settings.notifications = notifications;

    await saveSettings(settings);
  }

  // Check if user has completed basic profile setup
  static bool get hasBasicProfile {
    final settings = getSettings();
    return settings.weight != null &&
        settings.height != null &&
        settings.age != null &&
        settings.gender != null;
  }

  // Check if user has set custom calorie target (not default)
  static bool get hasCustomCalorieTarget {
    final settings = getSettings();
    return settings.dailyCalorieTarget != null;
  }

  static bool get isInitialized => _settingsBox != null;
}
