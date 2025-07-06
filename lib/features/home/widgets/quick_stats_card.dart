import 'package:flutter/material.dart';
import '../../../core/utils/localization_helper.dart';
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
    final l10n = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickStats,
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
                title: l10n.weeklyAverage,
                value: weeklyAverage > 0
                    ? weeklyAverage.toInt().toString()
                    : '--',
                unit: l10n.caloriesPerDay,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: StatCard(
                title: l10n.yesterday,
                value: yesterdayCalories > 0
                    ? yesterdayCalories.toInt().toString()
                    : '--',
                unit: l10n.calories.toLowerCase(),
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
                title: l10n.remaining,
                value: dailyTarget != null
                    ? '${(dailyTarget! - currentCalories).toInt()}'
                    : '--',
                unit: l10n.calories.toLowerCase(),
                color: Colors.blue[300]!,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: StatCard(
                title: l10n.progress,
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
