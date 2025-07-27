import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../core/utils/localization_helper.dart';

class ChartSection extends StatelessWidget {
  final int selectedChart;
  final int selectedPeriod;
  final List<ChartData> chartData;
  final Function(int) onChartChanged;
  final Function(int) onPeriodChanged;

  const ChartSection({
    Key? key,
    required this.selectedChart,
    required this.selectedPeriod,
    required this.chartData,
    required this.onChartChanged,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      children: [
        Container(
          height: 250,
          child: PageView(
            onPageChanged: onChartChanged,
            children: [
              _buildStatsPage(
                context,
                chartData,
                'calories',
                l10n.calories,
                Colors.orange,
              ),
              _buildStatsPage(
                context,
                chartData,
                'protein',
                l10n.protein,
                Colors.blue,
              ),
              _buildStatsPage(
                context,
                chartData,
                'carbs',
                l10n.carbs,
                Colors.green,
              ),
              _buildStatsPage(context, chartData, 'fat', l10n.fat, Colors.red),
            ],
          ),
        ),
        SizedBox(height: 12),
        // Fixed indicator dots outside PageView
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedChart == index
                    ? _getChartColor(index)
                    : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatsPage(
    BuildContext context,
    List<ChartData> data,
    String macroType,
    String title,
    Color color,
  ) {
    final l10n = L10n.of(context);
    final average = _calculateAverage(data, macroType);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title and average centered and more visible
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  ' - ${l10n.average}: ${average.toStringAsFixed(average % 1 == 0 ? 0 : 1)} ${_getChartUnit(context, selectedChart)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Period Toggle under average, left-aligned and smaller
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildPeriodText(context, l10n.sevenDays, 0),
              SizedBox(width: 24),
              _buildPeriodText(context, l10n.thisWeek, 1),
              SizedBox(width: 24),
              _buildPeriodText(context, l10n.thirtyDays, 2),
            ],
          ),

          SizedBox(height: 16),

          // Chart with proper spacing
          Expanded(child: _buildWaveChart(context, data, macroType, color)),
        ],
      ),
    );
  }

  Widget _buildPeriodText(BuildContext context, String title, int index) {
    final isSelected = selectedPeriod == index;
    return GestureDetector(
      onTap: () => onPeriodChanged(index),
      child: Container(
        padding: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(color: Colors.blue, width: 2))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildWaveChart(
    BuildContext context,
    List<ChartData> data,
    String macroType,
    Color color,
  ) {
    final l10n = L10n.of(context);
    final spots = <FlSpot>[];

    for (int i = 0; i < data.length; i++) {
      final value = data[i].getValue(macroType);
      if (value > 0) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    if (spots.isEmpty) {
      return Center(
        child: Text(
          l10n.noDataAvailable,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      );
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.1;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[200], strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(
                    data[index].dateLabel,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  );
                }
                return Container();
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: color,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverage(List<ChartData> data, String macroType) {
    if (data.isEmpty) return 0.0;

    double total = 0.0;
    int validDays = 0;

    for (var dayData in data) {
      final value = dayData.getValue(macroType);
      if (value > 0) {
        total += value;
        validDays++;
      }
    }

    return validDays > 0 ? total / validDays : 0.0;
  }

  Color _getChartColor(int index) {
    final colors = [Colors.orange, Colors.blue, Colors.green, Colors.red];
    return colors[index];
  }

  String _getChartUnit(BuildContext context, int index) {
    final l10n = L10n.of(context);
    final units = [l10n.kcal, 'g', 'g', 'g'];
    return units[index];
  }
}

// Data class to pass chart data
class ChartData {
  final DateTime date;
  final Map<String, double> macros;
  final String dateLabel;

  ChartData({
    required this.date,
    required this.macros,
    required this.dateLabel,
  });

  double getValue(String macroType) {
    return macros[macroType] ?? 0.0;
  }
}
