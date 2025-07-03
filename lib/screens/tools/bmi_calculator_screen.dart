// screens/tools/bmi_calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/user_settings_service.dart';
import '../../widgets/common/custom_card.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  // Result
  double? _bmiResult;
  String? _bmiCategory;
  Color? _categoryColor;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final settings = UserSettingsService.getSettings();

    if (settings.weight != null) {
      _weightController.text = settings.weight!.toString();
    }
    if (settings.height != null) {
      _heightController.text = settings.height!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Body Mass Index',
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
                            controller: _weightController,
                            label: 'Weight',
                            suffix: 'kg',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildCompactTextField(
                            controller: _heightController,
                            label: 'Height',
                            suffix: 'cm',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Calculate BMI',
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
            if (_bmiResult != null) ...[
              SizedBox(height: 16),
              CustomCard(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your BMI Result',
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
                            '${_bmiResult!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _categoryColor!.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _categoryColor!.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _bmiCategory!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _categoryColor!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // BMI Categories Reference
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BMI Categories',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildCategoryRow(
                            'Underweight',
                            '< 18.5',
                            Colors.blue,
                          ),
                          _buildCategoryRow(
                            'Normal weight',
                            '18.5 - 24.9',
                            Colors.green,
                          ),
                          _buildCategoryRow(
                            'Overweight',
                            '25.0 - 29.9',
                            Colors.orange,
                          ),
                          _buildCategoryRow('Obese', '≥ 30.0', Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
  }) {
    return Container(
      height: 44,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        validator: (value) {
          if (value?.isEmpty == true) return 'Required';
          if (double.tryParse(value!) == null) return 'Invalid';
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

  Widget _buildCategoryRow(String category, String range, Color color) {
    final isCurrentCategory = _bmiCategory == category;

    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentCategory ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrentCategory
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: isCurrentCategory ? color : Colors.grey[600],
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrentCategory
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: isCurrentCategory ? color : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _calculateBMI() async {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);

    // Convert height from cm to meters
    final heightInMeters = height / 100;

    // Calculate BMI
    final bmi = weight / (heightInMeters * heightInMeters);

    // Determine category and color
    String category;
    Color color;

    if (bmi < 18.5) {
      category = 'Underweight';
      color = Colors.blue;
    } else if (bmi < 25.0) {
      category = 'Normal weight';
      color = Colors.green;
    } else if (bmi < 30.0) {
      category = 'Overweight';
      color = Colors.orange;
    } else {
      category = 'Obese';
      color = Colors.red;
    }

    // Save updated user data
    await UserSettingsService.updateProfile(weight: weight, height: height);

    setState(() {
      _bmiResult = bmi;
      _bmiCategory = category;
      _categoryColor = color;
    });
  }
}
