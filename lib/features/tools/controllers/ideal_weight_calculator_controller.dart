import 'package:flutter/material.dart';
import '../../../data/repositories/settings_repository.dart';

class IdealWeightCalculatorController extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  IdealWeightCalculatorController({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  // Form controllers
  final heightController = TextEditingController();

  // Selected values
  String _selectedGender = 'male';

  // Result
  double? _idealWeightResult;
  double? _currentWeight;

  // Getters
  String get selectedGender => _selectedGender;
  double? get idealWeightResult => _idealWeightResult;
  double? get currentWeight => _currentWeight;

  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }

  void loadUserData() {
    final settings = _settingsRepository.getSettings();

    if (settings.height != null) {
      heightController.text = settings.height!.toString();
    }
    if (settings.gender != null) {
      _selectedGender = settings.gender!;
    }
    if (settings.weight != null) {
      _currentWeight = settings.weight!;
    }
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  Future<void> calculateIdealWeight() async {
    final height = double.parse(heightController.text);

    // Convert height from cm to inches
    final heightInInches = height / 2.54;

    // Robinson Formula
    double idealWeight;
    if (_selectedGender == 'male') {
      // Men: 52kg + 1.9kg per inch over 5 feet (60 inches)
      idealWeight = 52 + (1.9 * (heightInInches - 60));
    } else {
      // Women: 49kg + 1.7kg per inch over 5 feet (60 inches)
      idealWeight = 49 + (1.7 * (heightInInches - 60));
    }

    // Ensure minimum reasonable weight
    idealWeight = idealWeight.clamp(30.0, 200.0);

    // Save updated user data
    await _settingsRepository.updateProfile(
      height: height,
      gender: _selectedGender,
    );

    _idealWeightResult = idealWeight;
    notifyListeners();
  }
}
