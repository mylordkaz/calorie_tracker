// screens/tools/tools_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/common/custom_card.dart';
import 'tdee_calculator_screen.dart';

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
            _buildToolCard(
              context,
              'TDEE Calculator',
              'Calculate your daily calorie needs',
              Icons.local_fire_department,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TDEECalculatorScreen()),
              ),
            ),

            SizedBox(height: 12),

            // Placeholder for BMI Calculator
            _buildToolCard(
              context,
              'BMI Calculator',
              'Calculate your Body Mass Index',
              Icons.monitor_weight,
              Colors.blue,
              () {
                // TODO: Navigate to BMI Calculator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('BMI Calculator coming soon!')),
                );
              },
            ),

            SizedBox(height: 12),

            // Placeholder for Ideal Weight Calculator
            _buildToolCard(
              context,
              'Ideal Weight Calculator',
              'Find your ideal weight range',
              Icons.balance,
              Colors.green,
              () {
                // TODO: Navigate to Ideal Weight Calculator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ideal Weight Calculator coming soon!'),
                  ),
                );
              },
            ),

            SizedBox(height: 12),

            // Placeholder for Body Fat Calculator
            _buildToolCard(
              context,
              'Body Fat Calculator',
              'Estimate your body fat percentage',
              Icons.fitness_center,
              Colors.purple,
              () {
                // TODO: Navigate to Body Fat Calculator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Body Fat Calculator coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
