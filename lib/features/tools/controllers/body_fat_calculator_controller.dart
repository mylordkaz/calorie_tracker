import 'package:flutter/material.dart';
import 'dart:math';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/utils/localization_helper.dart';

class BodyFatCalculatorController extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  BodyFatCalculatorController({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  // Form controllers
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final neckController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();

  // Selected values
  String _selectedGender = 'male';

  // Result
  double? _bodyFatResult;
  String? _bodyFatCategory;
  Color? _categoryColor;

  // Getters
  String get selectedGender => _selectedGender;
  double? get bodyFatResult => _bodyFatResult;
  String? get bodyFatCategory => _bodyFatCategory;
  Color? get categoryColor => _categoryColor;

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    neckController.dispose();
    waistController.dispose();
    hipController.dispose();
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
    if (settings.neck != null) {
      neckController.text = settings.neck!.toString();
    }
    if (settings.waist != null) {
      waistController.text = settings.waist!.toString();
    }
    if (settings.hip != null) {
      hipController.text = settings.hip!.toString();
    }
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  Future<void> calculateBodyFat(BuildContext context) async {
    final l10n = L10n.of(context);

    final weight = double.parse(weightController.text);
    final height = double.parse(heightController.text);
    final age = int.parse(ageController.text);
    final neck = double.parse(neckController.text);
    final waist = double.parse(waistController.text);

    double? hip;
    if (_selectedGender == 'female' && hipController.text.isNotEmpty) {
      hip = double.parse(hipController.text);
    }

    double bodyFat;

    if (_selectedGender == 'male') {
      // US Navy formula for men
      bodyFat =
          495 /
              (1.0324 -
                  0.19077 * log(waist - neck) / ln10 +
                  0.15456 * log(height) / ln10) -
          450;
    } else {
      // US Navy formula for women (requires hip measurement)
      if (hip == null) {
        throw Exception('Hip measurement is required for women');
      }
      bodyFat =
          495 /
              (1.29579 -
                  0.35004 * log(waist + hip - neck) / ln10 +
                  0.22100 * log(height) / ln10) -
          450;
    }

    // Clamp result to reasonable range
    bodyFat = bodyFat.clamp(1.0, 60.0);

    // Determine category and color based on gender
    String category;
    Color color;

    if (_selectedGender == 'male') {
      if (bodyFat < 6) {
        category = l10n.essentialFat;
        color = Colors.blue;
      } else if (bodyFat < 14) {
        category = l10n.athletes;
        color = Colors.green;
      } else if (bodyFat < 18) {
        category = l10n.fitness;
        color = Colors.green;
      } else if (bodyFat < 25) {
        category = l10n.average;
        color = Colors.orange;
      } else {
        category = l10n.obese;
        color = Colors.red;
      }
    } else {
      if (bodyFat < 14) {
        category = l10n.essentialFat;
        color = Colors.blue;
      } else if (bodyFat < 21) {
        category = l10n.athletes;
        color = Colors.green;
      } else if (bodyFat < 25) {
        category = l10n.fitness;
        color = Colors.green;
      } else if (bodyFat < 32) {
        category = l10n.average;
        color = Colors.orange;
      } else {
        category = l10n.obese;
        color = Colors.red;
      }
    }

    // Save updated user data
    await _settingsRepository.updateProfile(
      weight: weight,
      height: height,
      age: age,
      gender: _selectedGender,
      neck: neck,
      waist: waist,
      hip: hip,
    );

    _bodyFatResult = bodyFat;
    _bodyFatCategory = category;
    _categoryColor = color;
    notifyListeners();
  }
}
