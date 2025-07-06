import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/body_fat_calculator_controller.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../core/utils/localization_helper.dart';

class BodyFatCalculatorScreen extends StatefulWidget {
  const BodyFatCalculatorScreen({super.key});

  @override
  _BodyFatCalculatorScreenState createState() =>
      _BodyFatCalculatorScreenState();
}

class _BodyFatCalculatorScreenState extends State<BodyFatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final BodyFatCalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BodyFatCalculatorController(
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
        title: Text(l10n.bodyFatCalculator),
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
                  l10n.estimateBodyFatPercentage,
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
                                controller: _controller.weightController,
                                label: l10n.weight,
                                suffix: 'kg',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.heightController,
                                label: l10n.height,
                                suffix: 'cm',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.ageController,
                                label: l10n.age,
                                suffix: l10n.years,
                                isInteger: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Gender
                        Container(
                          height: 44,
                          child: CustomDropdown<String>(
                            value: _controller.selectedGender,
                            hintText: l10n.gender,
                            items: [
                              DropdownItem(value: 'male', text: l10n.male),
                              DropdownItem(value: 'female', text: l10n.female),
                            ],
                            onChanged: (value) => _controller.setGender(value!),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Measurement Instructions
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.measurementInstructions,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                l10n.neckMeasurementTip +
                                    '\n' +
                                    l10n.waistMeasurementTip +
                                    '\n' +
                                    (_controller.selectedGender == 'female'
                                        ? l10n.hipMeasurementTip + '\n'
                                        : '') +
                                    l10n.measurementAccuracyTip,
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
                          l10n.bodyMeasurements,
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
                                controller: _controller.neckController,
                                label: l10n.neck,
                                suffix: 'cm',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.waistController,
                                label: l10n.waist,
                                suffix: 'cm',
                              ),
                            ),
                          ],
                        ),

                        // Hip measurement (only for women)
                        if (_controller.selectedGender == 'female') ...[
                          SizedBox(height: 12),
                          _buildCompactTextField(
                            controller: _controller.hipController,
                            label: l10n.hip,
                            suffix: 'cm',
                          ),
                        ],

                        SizedBox(height: 20),

                        // Calculate Button
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () => _calculateBodyFat(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.calculateBodyFat,
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
                if (_controller.bodyFatResult != null) ...[
                  SizedBox(height: 16),
                  CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.yourBodyFatResult,
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
                                '${_controller.bodyFatResult!.toStringAsFixed(1)}%',
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
                                  color: _controller.categoryColor!.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _controller.categoryColor!
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _controller.bodyFatCategory!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _controller.categoryColor!,
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
                                _controller.selectedGender == 'male'
                                    ? l10n.bodyFatCategoriesMen
                                    : l10n.bodyFatCategoriesWomen,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              if (_controller.selectedGender == 'male') ...[
                                _buildCategoryRow(
                                  l10n.essentialFat,
                                  '2-5%',
                                  Colors.blue,
                                ),
                                _buildCategoryRow(
                                  l10n.athletes,
                                  '6-13%',
                                  Colors.green,
                                ),
                                _buildCategoryRow(
                                  l10n.fitness,
                                  '14-17%',
                                  Colors.green,
                                ),
                                _buildCategoryRow(
                                  l10n.average,
                                  '18-24%',
                                  Colors.orange,
                                ),
                                _buildCategoryRow(
                                  l10n.obese,
                                  '25%+',
                                  Colors.red,
                                ),
                              ] else ...[
                                _buildCategoryRow(
                                  l10n.essentialFat,
                                  '10-13%',
                                  Colors.blue,
                                ),
                                _buildCategoryRow(
                                  l10n.athletes,
                                  '14-20%',
                                  Colors.green,
                                ),
                                _buildCategoryRow(
                                  l10n.fitness,
                                  '21-24%',
                                  Colors.green,
                                ),
                                _buildCategoryRow(
                                  l10n.average,
                                  '25-31%',
                                  Colors.orange,
                                ),
                                _buildCategoryRow(
                                  l10n.obese,
                                  '32%+',
                                  Colors.red,
                                ),
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
                                l10n.usNavyMethod,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                l10n.usNavyDesc,
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
          );
        },
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    bool isInteger = false,
  }) {
    final l10n = L10n.of(context);
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
          if (value?.isEmpty == true) return l10n.required;
          if (isInteger) {
            if (int.tryParse(value!) == null) return l10n.invalid;
          } else {
            if (double.tryParse(value!) == null) return l10n.invalid;
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
    final isCurrentCategory = _controller.bodyFatCategory == category;

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

    try {
      await _controller.calculateBodyFat(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }
}
