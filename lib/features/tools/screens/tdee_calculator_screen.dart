import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/tdee_calculator_controller.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../core/utils/localization_helper.dart';

class TDEECalculatorScreen extends StatefulWidget {
  const TDEECalculatorScreen({super.key});

  @override
  _TDEECalculatorScreenState createState() => _TDEECalculatorScreenState();
}

class _TDEECalculatorScreenState extends State<TDEECalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TDEECalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TDEECalculatorController(
      settingsRepository: RepositoryFactory.createSettingsRepository(),
    );
    _controller.loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.tdeeCalculator),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalDailyEnergyExpenditure,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 20),

                CustomCard(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weight and Height
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.weightController,
                                label: l10n.weight,
                                suffix: 'kg',
                                isDecimal: true,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.heightController,
                                label: l10n.height,
                                suffix: 'cm',
                                isDecimal: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Age and Gender
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.ageController,
                                label: l10n.age,
                                suffix: l10n.years,
                                isDecimal: false,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: CustomDropdown<String>(
                                value: _controller.selectedGender,
                                labelText: l10n.gender,
                                items: [
                                  DropdownItem(value: 'male', text: l10n.male),
                                  DropdownItem(
                                    value: 'female',
                                    text: l10n.female,
                                  ),
                                ],
                                onChanged: (value) =>
                                    _controller.setGender(value!),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Activity Level
                        CustomDropdown<String>(
                          value: _controller.selectedActivityLevel,
                          labelText: l10n.activityLevel,
                          items: [
                            DropdownItem(
                              value: 'sedentary',
                              text: l10n.sedentaryNoExercise,
                            ),
                            DropdownItem(
                              value: 'light_low',
                              text: l10n.lightOneToTwoDays,
                            ),
                            DropdownItem(
                              value: 'light',
                              text: l10n.lightTwoToThreeDays,
                            ),
                            DropdownItem(
                              value: 'moderate_low',
                              text: l10n.moderateThreeToFourDays,
                            ),
                            DropdownItem(
                              value: 'moderate',
                              text: l10n.moderateFourToFiveDays,
                            ),
                            DropdownItem(
                              value: 'active',
                              text: l10n.activeSixToSevenDays,
                            ),
                            DropdownItem(
                              value: 'very_active',
                              text: l10n.veryActiveTwiceDaily,
                            ),
                            DropdownItem(
                              value: 'extremely_active',
                              text: l10n.extremelyActivePhysicalJob,
                            ),
                          ],
                          onChanged: (value) =>
                              _controller.setActivityLevel(value!),
                        ),

                        SizedBox(height: 20),

                        // Calculate Button
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () => _calculateTDEE(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.calculateTdee,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Result Card
                if (_controller.tdeeResult != null) ...[
                  SizedBox(height: 16),
                  CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.yourTdeeResult,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),

                        Center(
                          child: Column(
                            children: [
                              Text(
                                '${_controller.tdeeResult!.toInt()}',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                l10n.caloriesPerDay,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        Text(
                          l10n.tdeeMaintenanceDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16),

                        // Set as daily target button
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: OutlinedButton(
                            onPressed: _setAsDailyTarget,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.setAsDailyCalorieTarget,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required bool isDecimal,
  }) {
    final l10n = L10n.of(context);
    return Container(
      height: 44,
      child: TextFormField(
        controller: controller,
        keyboardType: isDecimal
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        inputFormatters: isDecimal
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
            : [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value?.isEmpty == true) return l10n.required;
          if (isDecimal) {
            if (double.tryParse(value!) == null) return l10n.invalid;
          } else {
            if (int.tryParse(value!) == null) return l10n.invalid;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  void _calculateTDEE() async {
    if (!_formKey.currentState!.validate()) return;
    await _controller.calculateTDEE();
  }

  void _setAsDailyTarget() async {
    final l10n = L10n.of(context);
    await _controller.setAsDailyTarget();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.dailyCalorieTargetUpdatedTo(_controller.tdeeResult!.toInt()),
          ),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}
