import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/ideal_weight_calculator_controller.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../core/utils/localization_helper.dart';

class IdealWeightCalculatorScreen extends StatefulWidget {
  const IdealWeightCalculatorScreen({super.key});

  @override
  _IdealWeightCalculatorScreenState createState() =>
      _IdealWeightCalculatorScreenState();
}

class _IdealWeightCalculatorScreenState
    extends State<IdealWeightCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final IdealWeightCalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = IdealWeightCalculatorController(
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
        title: Text(l10n.idealWeightCalculator),
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
                  l10n.findIdealWeightRange,
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
                        // Height and Gender
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactTextField(
                                controller: _controller.heightController,
                                label: l10n.height,
                                suffix: 'cm',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: CustomDropdown<String>(
                                value: _controller.selectedGender,
                                hintText: l10n.gender,
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

                        SizedBox(height: 20),

                        // Calculate Button
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () => _calculateIdealWeight(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.calculateIdealWeight,
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
                if (_controller.idealWeightResult != null) ...[
                  SizedBox(height: 16),
                  CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.yourIdealWeight,
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
                                '${_controller.idealWeightResult!.toStringAsFixed(1)} kg',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                l10n.idealWeight,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Weight Range
                        Container(
                          padding: EdgeInsets.all(16),
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
                                l10n.healthyWeightRange,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${(_controller.idealWeightResult! - 5).toStringAsFixed(1)} - ${(_controller.idealWeightResult! + 5).toStringAsFixed(1)} kg',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                l10n.rangeBasedOnIdealWeight,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Current weight comparison if available
                        if (_controller.currentWeight != null) ...[
                          SizedBox(height: 16),
                          _buildWeightComparison(),
                        ],

                        SizedBox(height: 16),

                        // Formula info
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
                                l10n.robinsonFormula,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Builder(
                                builder: (context) {
                                  return Text(
                                    _controller.selectedGender == 'male'
                                        ? l10n.robinsonFormulaMen
                                        : l10n.robinsonFormulaWomen,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
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
  }) {
    final l10n = L10n.of(context);
    return Container(
      height: 44,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        validator: (value) {
          if (value?.isEmpty == true) return l10n.required;
          if (double.tryParse(value!) == null) return l10n.invalid;
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

  Widget _buildWeightComparison() {
    final difference =
        _controller.currentWeight! - _controller.idealWeightResult!;
    final isAbove = difference > 0;
    final isInRange = difference.abs() <= 5;
    final l10n = L10n.of(context);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isInRange) {
      statusColor = Colors.green;
      statusText = l10n.withinIdealRange;
      statusIcon = Icons.check_circle;
    } else if (isAbove) {
      statusColor = Colors.orange;
      statusText = l10n.aboveIdeal(difference.toStringAsFixed(1));
      ;
      statusIcon = Icons.trending_up;
    } else {
      statusColor = Colors.blue;
      statusText = l10n.belowIdeal(difference.abs().toStringAsFixed(1));
      statusIcon = Icons.trending_down;
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.currentWeight(
                    _controller.currentWeight!.toStringAsFixed(1),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _calculateIdealWeight() async {
    if (!_formKey.currentState!.validate()) return;
    await _controller.calculateIdealWeight();
  }
}
