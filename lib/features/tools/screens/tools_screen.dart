import 'package:flutter/material.dart';
import '../widgets/tool_card.dart';
import 'tdee_calculator_screen.dart';
import 'bmi_calculator_screen.dart';
import 'ideal_weight_calculator_screen.dart';
import 'body_fat_calculator_screen.dart';
import '../../../core/utils/localization_helper.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Tools'),
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
              l10n.healthAndFitnessCalculators,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              l10n.calculateImportantHealthMetrics,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),

            // TDEE Calculator
            ToolCard(
              title: l10n.tdeeCalculator,
              description: l10n.tdeeCalculatorDescription,
              icon: Icons.local_fire_department,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TDEECalculatorScreen()),
              ),
            ),

            SizedBox(height: 12),

            // BMI Calculator
            ToolCard(
              title: l10n.bmiCalculator,
              description: l10n.bmiCalculatorDescription,
              icon: Icons.monitor_weight,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMICalculatorScreen()),
              ),
            ),

            SizedBox(height: 12),

            // Ideal Weight Calculator
            ToolCard(
              title: l10n.idealWeightCalculator,
              description: l10n.idealWeightCalculatorDescription,
              icon: Icons.balance,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdealWeightCalculatorScreen(),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Body Fat Calculator
            ToolCard(
              title: l10n.bodyFatCalculator,
              description: l10n.bodyFatCalculatorDescription,
              icon: Icons.fitness_center,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BodyFatCalculatorScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
