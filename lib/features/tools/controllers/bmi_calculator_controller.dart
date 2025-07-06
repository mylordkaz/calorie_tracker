import 'package:flutter/material.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/utils/localization_helper.dart';

class BMICalculatorController extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  BMICalculatorController({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  // Form controllers
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  // Result
  double? _bmiResult;
  String? _bmiCategory;
  Color? _categoryColor;

  // Getters
  double? get bmiResult => _bmiResult;
  String? get bmiCategory => _bmiCategory;
  Color? get categoryColor => _categoryColor;

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
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
    notifyListeners();
  }

  Future<void> calculateBMI(BuildContext context) async {
    final l10n = L10n.of(context);

    final weight = double.parse(weightController.text);
    final height = double.parse(heightController.text);

    // Convert height from cm to meters
    final heightInMeters = height / 100;

    // Calculate BMI
    final bmi = weight / (heightInMeters * heightInMeters);

    // Determine category and color
    String category;
    Color color;

    if (bmi < 18.5) {
      category = l10n.underweight;
      color = Colors.blue;
    } else if (bmi < 25.0) {
      category = l10n.normalWeight;
      color = Colors.green;
    } else if (bmi < 30.0) {
      category = l10n.overweight;
      color = Colors.orange;
    } else {
      category = l10n.obese;
      color = Colors.red;
    }

    // Save updated user data
    await _settingsRepository.updateProfile(weight: weight, height: height);

    _bmiResult = bmi;
    _bmiCategory = category;
    _categoryColor = color;
    notifyListeners();
  }
}
