import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/ideal_weight_calculator_controller.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_dropdown.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Ideal Weight Calculator'),
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
                  'Find your ideal weight range (Robinson Formula)',
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
                                label: 'Height',
                                suffix: 'cm',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: CustomDropdown<String>(
                                value: _controller.selectedGender,
                                hintText: 'Gender',
                                items: [
                                  DropdownItem(value: 'male', text: 'Male'),
                                  DropdownItem(value: 'female', text: 'Female'),
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
                              'Calculate Ideal Weight',
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
                          'Your Ideal Weight',
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
                                'ideal weight',
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
                                'Healthy Weight Range',
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
                                'Range based on ±5kg from ideal weight',
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
                                'Robinson Formula',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _controller.selectedGender == 'male'
                                    ? 'Men: 52kg + 1.9kg per inch over 5 feet'
                                    : 'Women: 49kg + 1.7kg per inch over 5 feet',
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

  Widget _buildWeightComparison() {
    final difference =
        _controller.currentWeight! - _controller.idealWeightResult!;
    final isAbove = difference > 0;
    final isInRange = difference.abs() <= 5;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isInRange) {
      statusColor = Colors.green;
      statusText = 'Within ideal range';
      statusIcon = Icons.check_circle;
    } else if (isAbove) {
      statusColor = Colors.orange;
      statusText = '${difference.toStringAsFixed(1)}kg above ideal';
      statusIcon = Icons.trending_up;
    } else {
      statusColor = Colors.blue;
      statusText = '${difference.abs().toStringAsFixed(1)}kg below ideal';
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
                  'Current Weight: ${_controller.currentWeight!.toStringAsFixed(1)}kg',
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
