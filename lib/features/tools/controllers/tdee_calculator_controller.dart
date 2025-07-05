import 'package:flutter/material.dart';
import '../../../data/repositories/settings_repository.dart';

class TDEECalculatorController extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  TDEECalculatorController({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  // Form controllers
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  // Selected values
  String _selectedGender = 'male';
  String _selectedActivityLevel = 'moderate';

  // Result
  double? _tdeeResult;

  // Getters
  String get selectedGender => _selectedGender;
  String get selectedActivityLevel => _selectedActivityLevel;
  double? get tdeeResult => _tdeeResult;

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void loadUserData() {
    final settings = _settingsRepository.getSettings();

    if (settings.weight != null) {
      weightController.text = settings.weight!.toString();
    }
    if (settings.height != null) {
      heightController.text = settings.height!.toString();
    }
    if (settings.age != null) {
      ageController.text = settings.age!.toString();
    }
    if (settings.gender != null) {
      _selectedGender = settings.gender!;
    }
    if (settings.activityLevel != null) {
      _selectedActivityLevel = settings.activityLevel!;
    }
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setActivityLevel(String activityLevel) {
    _selectedActivityLevel = activityLevel;
    notifyListeners();
  }

  Future<void> calculateTDEE() async {
    final weight = double.parse(weightController.text);
    final height = double.parse(heightController.text);
    final age = int.parse(ageController.text);

    // Mifflin-St Jeor Formula
    double bmr;
    if (_selectedGender == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Activity multiplier
    double activityMultiplier;
    switch (_selectedActivityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'light_low':
        activityMultiplier = 1.3;
        break;
      case 'light':
        activityMultiplier = 1.4;
        break;
      case 'moderate_low':
        activityMultiplier = 1.55;
        break;
      case 'moderate':
        activityMultiplier = 1.65;
        break;
      case 'active':
        activityMultiplier = 1.725;
        break;
      case 'very_active':
        activityMultiplier = 1.9;
        break;
      case 'extremely_active':
        activityMultiplier = 2.1;
        break;
      default:
        activityMultiplier = 1.55;
    }

    final tdee = bmr * activityMultiplier;

    // Save updated user data
    await _settingsRepository.updateProfile(
      weight: weight,
      height: height,
      age: age,
      gender: _selectedGender,
      activityLevel: _selectedActivityLevel,
    );

    _tdeeResult = tdee;
    notifyListeners();
  }

  Future<void> setAsDailyTarget() async {
    if (_tdeeResult != null) {
      await _settingsRepository.setDailyCalorieTarget(_tdeeResult!);
    }
  }
}
