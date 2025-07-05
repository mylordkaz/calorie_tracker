import 'package:flutter/material.dart';
import '../widgets/tool_card.dart';
import 'tdee_calculator_screen.dart';
import 'bmi_calculator_screen.dart';
import 'ideal_weight_calculator_screen.dart';
import 'body_fat_calculator_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Health & Fitness Calculators',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Calculate important health metrics',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),

            // TDEE Calculator
            ToolCard(
              title: 'TDEE Calculator',
              description: 'Calculate your daily calorie needs',
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
              title: 'BMI Calculator',
              description: 'Calculate your Body Mass Index',
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
              title: 'Ideal Weight Calculator',
              description: 'Find your ideal weight range',
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
              title: 'Body Fat Calculator',
              description: 'Estimate your body fat percentage',
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
