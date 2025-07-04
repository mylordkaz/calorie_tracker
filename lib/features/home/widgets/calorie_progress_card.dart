import 'package:flutter/material.dart';

class CalorieProgressCard extends StatelessWidget {
  final double currentCalories;
  final double? dailyTarget;
  final Map<String, double> currentMacros;
  final VoidCallback onAddFood;
  final VoidCallback onSetTarget;

  const CalorieProgressCard({
    Key? key,
    required this.currentCalories,
    required this.dailyTarget,
    required this.currentMacros,
    required this.onAddFood,
    required this.onSetTarget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = dailyTarget != null ? currentCalories / dailyTarget! : 0.0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 14),
          _buildProgressRing(progress),
          SizedBox(height: 14),
          _buildMacrosSummary(),
          SizedBox(height: 14),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Today - ${DateTime.now().toString().split(' ')[0]}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onSetTarget,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: dailyTarget != null
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: dailyTarget != null
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Text(
              dailyTarget != null
                  ? 'Target: ${dailyTarget!.toInt()}'
                  : 'Set Target',
              style: TextStyle(
                fontSize: 11,
                color: dailyTarget != null ? Colors.blue : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRing(double progress) {
    return Container(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                dailyTarget != null
                    ? (progress <= 1.0 ? Colors.blue : Colors.grey[600]!)
                    : Colors.grey[400]!,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${currentCalories.toInt()}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                dailyTarget != null ? 'of ${dailyTarget!.toInt()}' : 'calories',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              if (dailyTarget != null)
                Text(
                  'calories',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosSummary() {
    return Text(
      'Protein: ${currentMacros['protein']!.toInt()}g • Carbs: ${currentMacros['carbs']!.toInt()}g • Fat: ${currentMacros['fat']!.toInt()}g',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 45,
        child: ElevatedButton(
          onPressed: onAddFood,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            'Add Food',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
