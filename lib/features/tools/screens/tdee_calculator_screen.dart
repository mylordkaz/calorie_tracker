import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/tdee_calculator_controller.dart';
import '../../../shared/widgets/custom_card.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('TDEE Calculator'),
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
                  'Total Daily Energy Expenditure',
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
                                label: 'Weight',
                                suffix: 'kg',
                                isDecimal: true,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.heightController,
                                label: 'Height',
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
                                label: 'Age',
                                suffix: 'years',
                                isDecimal: false,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 44,
                                child: DropdownButtonFormField<String>(
                                  value: _controller.selectedGender,
                                  items: [
                                    DropdownMenuItem(
                                      value: 'male',
                                      child: Text(
                                        'Male',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'female',
                                      child: Text(
                                        'Female',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) =>
                                      _controller.setGender(value!),
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Activity Level
                        Container(
                          height: 44,
                          child: DropdownButtonFormField<String>(
                            value: _controller.selectedActivityLevel,
                            items: [
                              DropdownMenuItem(
                                value: 'sedentary',
                                child: Text(
                                  'Sedentary (no exercise)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'light_low',
                                child: Text(
                                  'Light (1-2 days/week)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'light',
                                child: Text(
                                  'Light (2-3 days/week)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'moderate_low',
                                child: Text(
                                  'Moderate (3-4 days/week)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'moderate',
                                child: Text(
                                  'Moderate (4-5 days/week)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'active',
                                child: Text(
                                  'Active (6-7 days/week)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'very_active',
                                child: Text(
                                  'Very Active (2x daily)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'extremely_active',
                                child: Text(
                                  'Extreme (physical job)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                _controller.setActivityLevel(value!),
                            decoration: InputDecoration(
                              labelText: 'Activity Level',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
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
                              'Calculate TDEE',
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
                          'Your TDEE Result',
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
                                'calories per day',
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
                          'This is your estimated daily calorie needs to maintain your current weight.',
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
                              'Set as Daily Calorie Target',
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
          if (value?.isEmpty == true) return 'Required';
          if (isDecimal) {
            if (double.tryParse(value!) == null) return 'Invalid';
          } else {
            if (int.tryParse(value!) == null) return 'Invalid';
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
    await _controller.setAsDailyTarget();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Daily calorie target updated to ${_controller.tdeeResult!.toInt()} calories',
          ),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}
