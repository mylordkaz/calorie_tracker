import 'package:flutter/material.dart';
import '../../../shared/widgets/stat_card.dart';

class QuickStatsCard extends StatelessWidget {
  final double weeklyAverage;
  final double yesterdayCalories;
  final double? dailyTarget;
  final double currentCalories;

  const QuickStatsCard({
    Key? key,
    required this.weeklyAverage,
    required this.yesterdayCalories,
    required this.dailyTarget,
    required this.currentCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Weekly Average',
                value: weeklyAverage > 0
                    ? weeklyAverage.toInt().toString()
                    : '--',
                unit: 'calories/day',
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: StatCard(
                title: 'Yesterday',
                value: yesterdayCalories > 0
                    ? yesterdayCalories.toInt().toString()
                    : '--',
                unit: 'calories',
                color: Colors.grey[600]!,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Remaining',
                value: dailyTarget != null
                    ? '${(dailyTarget! - currentCalories).toInt()}'
                    : '--',
                unit: 'calories',
                color: Colors.blue[300]!,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: StatCard(
                title: 'Progress',
                value: dailyTarget != null
                    ? '${((currentCalories / dailyTarget!) * 100).toInt()}'
                    : '--',
                unit: '%',
                color: Colors.grey[700]!,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
