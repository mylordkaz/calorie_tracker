import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../services/user_settings_service.dart';
import '../../widgets/common/custom_card.dart';

class BodyFatCalculatorScreen extends StatefulWidget {
  const BodyFatCalculatorScreen({super.key});

  @override
  _BodyFatCalculatorScreenState createState() =>
      _BodyFatCalculatorScreenState();
}

class _BodyFatCalculatorScreenState extends State<BodyFatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _neckController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController(); // Only for women

  // Selected values
  String _selectedGender = 'male';

  // Result
  double? _bodyFatResult;
  String? _bodyFatCategory;
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
    _ageController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _hipController.dispose();
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
    if (settings.age != null) {
      _ageController.text = settings.age!.toString();
    }
    if (settings.gender != null) {
      _selectedGender = settings.gender!;
    }
    if (settings.neck != null) {
      _neckController.text = settings.neck!.toString();
    }
    if (settings.waist != null) {
      _waistController.text = settings.waist!.toString();
    }
    if (settings.hip != null) {
      _hipController.text = settings.hip!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Body Fat Calculator'),
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
              'Estimate body fat percentage (US Navy Method)',
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
                    // Weight, Height, Age
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactTextField(
                            controller: _weightController,
                            label: 'Weight',
                            suffix: 'kg',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactTextField(
                            controller: _heightController,
                            label: 'Height',
                            suffix: 'cm',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactTextField(
                            controller: _ageController,
                            label: 'Age',
                            suffix: 'years',
                            isInteger: true,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Gender
                    Container(
                      height: 44,
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
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
                            setState(() => _selectedGender = value!),
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
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Measurement Instructions
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Measurement Instructions',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '• Neck: Measure just below the Adam\'s apple\n'
                                    '• Waist: Measure at the narrowest point\n' +
                                (_selectedGender == 'female'
                                    ? '• Hip: Measure at the widest point\n'
                                    : '') +
                                '• Measure without clothes for accuracy',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Body Measurements
                    Text(
                      'Body Measurements',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 12),

                    // Neck and Waist
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactTextField(
                            controller: _neckController,
                            label: 'Neck',
                            suffix: 'cm',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildCompactTextField(
                            controller: _waistController,
                            label: 'Waist',
                            suffix: 'cm',
                          ),
                        ),
                      ],
                    ),

                    // Hip measurement (only for women)
                    if (_selectedGender == 'female') ...[
                      SizedBox(height: 12),
                      _buildCompactTextField(
                        controller: _hipController,
                        label: 'Hip',
                        suffix: 'cm',
                      ),
                    ],

                    SizedBox(height: 20),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _calculateBodyFat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Calculate Body Fat',
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
            if (_bodyFatResult != null) ...[
              SizedBox(height: 16),
              CustomCard(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Body Fat Result',
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
                            '${_bodyFatResult!.toStringAsFixed(1)}%',
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
                              _bodyFatCategory!,
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

                    // Body Fat Categories Reference
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
                            'Body Fat Categories (${_selectedGender == 'male' ? 'Men' : 'Women'})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          if (_selectedGender == 'male') ...[
                            _buildCategoryRow(
                              'Essential Fat',
                              '2-5%',
                              Colors.blue,
                            ),
                            _buildCategoryRow(
                              'Athletes',
                              '6-13%',
                              Colors.green,
                            ),
                            _buildCategoryRow(
                              'Fitness',
                              '14-17%',
                              Colors.green,
                            ),
                            _buildCategoryRow(
                              'Average',
                              '18-24%',
                              Colors.orange,
                            ),
                            _buildCategoryRow('Obese', '25%+', Colors.red),
                          ] else ...[
                            _buildCategoryRow(
                              'Essential Fat',
                              '10-13%',
                              Colors.blue,
                            ),
                            _buildCategoryRow(
                              'Athletes',
                              '14-20%',
                              Colors.green,
                            ),
                            _buildCategoryRow(
                              'Fitness',
                              '21-24%',
                              Colors.green,
                            ),
                            _buildCategoryRow(
                              'Average',
                              '25-31%',
                              Colors.orange,
                            ),
                            _buildCategoryRow('Obese', '32%+', Colors.red),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Method info
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'US Navy Method',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Developed by the US Navy, this method estimates body fat using body circumference measurements. Results are estimates and may vary from other methods.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
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
    bool isInteger = false,
  }) {
    return Container(
      height: 44,
      child: TextFormField(
        controller: controller,
        keyboardType: isInteger
            ? TextInputType.number
            : TextInputType.numberWithOptions(decimal: true),
        inputFormatters: isInteger
            ? [FilteringTextInputFormatter.digitsOnly]
            : [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
        validator: (value) {
          if (value?.isEmpty == true) return 'Required';
          if (isInteger) {
            if (int.tryParse(value!) == null) return 'Invalid';
          } else {
            if (double.tryParse(value!) == null) return 'Invalid';
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

  Widget _buildCategoryRow(String category, String range, Color color) {
    final isCurrentCategory = _bodyFatCategory == category;

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

  void _calculateBodyFat() async {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final age = int.parse(_ageController.text);
    final neck = double.parse(_neckController.text);
    final waist = double.parse(_waistController.text);

    double? hip;
    if (_selectedGender == 'female') {
      if (_hipController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hip measurement is required for women')),
        );
        return;
      }
      hip = double.parse(_hipController.text);
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
      if (_hipController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hip measurement is required for women')),
        );
        return;
      }
      final hip = double.parse(_hipController.text);
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
        category = 'Essential Fat';
        color = Colors.blue;
      } else if (bodyFat < 14) {
        category = 'Athletes';
        color = Colors.green;
      } else if (bodyFat < 18) {
        category = 'Fitness';
        color = Colors.green;
      } else if (bodyFat < 25) {
        category = 'Average';
        color = Colors.orange;
      } else {
        category = 'Obese';
        color = Colors.red;
      }
    } else {
      if (bodyFat < 14) {
        category = 'Essential Fat';
        color = Colors.blue;
      } else if (bodyFat < 21) {
        category = 'Athletes';
        color = Colors.green;
      } else if (bodyFat < 25) {
        category = 'Fitness';
        color = Colors.green;
      } else if (bodyFat < 32) {
        category = 'Average';
        color = Colors.orange;
      } else {
        category = 'Obese';
        color = Colors.red;
      }
    }

    // Save updated user data
    await UserSettingsService.updateProfile(
      weight: weight,
      height: height,
      age: age,
      gender: _selectedGender,
      neck: neck,
      waist: waist,
      hip: hip,
    );

    setState(() {
      _bodyFatResult = bodyFat;
      _bodyFatCategory = category;
      _categoryColor = color;
    });
  }
}
