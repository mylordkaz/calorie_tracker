import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/daily_tracking_service.dart';
import '../../widgets/common/custom_card.dart';
import 'add_entry_for_date_screen.dart';
import '../../services/food_database_service.dart'; // Add this
import '../../models/daily_entry.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedPeriod = 1; // 0: 7 days, 1: Current Week, 2: 30 days
  int _selectedChart = 0; // 0: calories, 1: protein, 2: carbs, 3: fat
  PageController _chartPageController = PageController();

  // Calendar state
  DateTime _currentCalendarMonth = DateTime.now();
  DateTime? _selectedDate;
  List<DateTime> _datesWithEntries = [];

  @override
  void initState() {
    super.initState();
    _loadCalendarData();
  }

  @override
  void dispose() {
    _chartPageController.dispose();
    super.dispose();
  }

  void _loadCalendarData() {
    setState(() {
      _datesWithEntries = DailyTrackingService.getDatesWithEntriesForMonth(
        _currentCalendarMonth.year,
        _currentCalendarMonth.month,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Statistics'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(),
            SizedBox(height: 24),
            _buildCalendarSection(),
            SizedBox(height: 24),
            _buildDayDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    final data = _getData();

    return Container(
      height: 280,
      child: PageView(
        controller: _chartPageController,
        onPageChanged: (index) {
          setState(() {
            _selectedChart = index;
          });
        },
        children: [
          _buildStatsPage(data, 'calories', 'Calories', Colors.orange),
          _buildStatsPage(data, 'protein', 'Protein', Colors.blue),
          _buildStatsPage(data, 'carbs', 'Carbs', Colors.green),
          _buildStatsPage(data, 'fat', 'Fat', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatsPage(
    List<Map<String, dynamic>> data,
    String macroType,
    String title,
    Color color,
  ) {
    final average = DailyTrackingService.calculateAverage(data, macroType);

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
                  ' - Avg: ${average.toStringAsFixed(average % 1 == 0 ? 0 : 1)} ${_getChartUnit(_selectedChart)}',
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
              _buildPeriodText('7 Days', 0),
              SizedBox(width: 24),
              _buildPeriodText('This Week', 1),
              SizedBox(width: 24),
              _buildPeriodText('30 Days', 2),
            ],
          ),

          SizedBox(height: 16),

          // Chart with proper spacing
          Expanded(child: _buildWaveChart(data, macroType, color)),

          SizedBox(height: 16),

          // Chart indicators (dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedChart == index
                      ? _getChartColor(index)
                      : Colors.grey[300],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodText(String title, int index) {
    final isSelected = _selectedPeriod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = index;
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(color: Colors.green, width: 2))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12, // Reduced from 14 to 12
          ),
        ),
      ),
    );
  }

  Widget _buildWaveChart(
    List<Map<String, dynamic>> data,
    String macroType,
    Color color,
  ) {
    final spots = <FlSpot>[];

    for (int i = 0; i < data.length; i++) {
      final value = data[i]['macros'][macroType] as double;
      if (value > 0) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No data available',
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
                  final date = data[index]['date'] as DateTime;
                  return Text(
                    '${date.day}/${date.month}',
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

  Widget _buildCalendarSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(_currentCalendarMonth.month)} ${_currentCalendarMonth.year}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentCalendarMonth = DateTime(
                          _currentCalendarMonth.year,
                          _currentCalendarMonth.month - 1,
                        );
                      });
                      _loadCalendarData();
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentCalendarMonth = DateTime(
                          _currentCalendarMonth.year,
                          _currentCalendarMonth.month + 1,
                        );
                      });
                      _loadCalendarData();
                    },
                    icon: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),

          // Weekday headers
          Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (day) => Expanded(
                    child: Container(
                      height: 32,
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 8),

          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentCalendarMonth.year,
      _currentCalendarMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentCalendarMonth.year,
      _currentCalendarMonth.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7
    final daysInMonth = lastDayOfMonth.day;

    // Calculate previous month info
    final prevMonth = DateTime(
      _currentCalendarMonth.year,
      _currentCalendarMonth.month - 1,
      1,
    );
    final lastDayOfPrevMonth = DateTime(
      prevMonth.year,
      prevMonth.month + 1,
      0,
    ).day;

    List<Widget> calendarDays = [];

    // Add gray days from previous month
    for (int i = firstDayWeekday - 1; i > 0; i--) {
      final day = lastDayOfPrevMonth - i + 1;
      calendarDays.add(
        Container(
          margin: EdgeInsets.all(1),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      );
    }

    // Add days of current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        _currentCalendarMonth.year,
        _currentCalendarMonth.month,
        day,
      );
      final hasEntries = _datesWithEntries.any(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );
      final isSelected =
          _selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day;
      final isToday =
          DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      calendarDays.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : isToday
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.transparent,
              shape: (isSelected || isToday)
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              border: isToday && !isSelected
                  ? Border.all(color: Colors.blue, width: 1.0)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isToday
                          ? Colors.blue
                          : Colors.black87,
                    ),
                  ),
                ),
                if (hasEntries)
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Add gray days from next month to complete the grid
    int nextMonthDay = 1;
    while (calendarDays.length % 7 != 0) {
      calendarDays.add(
        Container(
          margin: EdgeInsets.all(1),
          child: Center(
            child: Text(
              nextMonthDay.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      );
      nextMonthDay++;
    }

    // Organize into weeks (rows of 7)
    List<Widget> weeks = [];
    for (int i = 0; i < calendarDays.length; i += 7) {
      weeks.add(
        Container(
          height: 44,
          child: Row(
            children: calendarDays
                .skip(i)
                .take(7)
                .map((day) => Expanded(child: day))
                .toList(),
          ),
        ),
      );
    }

    return Column(children: weeks);
  }

  Widget _buildDayDetailsSection() {
    if (_selectedDate == null) {
      return CustomCard(
        child: Container(
          height: 120,
          child: Center(
            child: Text(
              'Select a date to view details',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    final macros = DailyTrackingService.getMacrosForDate(_selectedDate!);
    final hasEntries = macros['calories']! > 0;
    final foodEntries = DailyTrackingService.getFoodEntriesForDate(
      _selectedDate!,
    );
    final mealEntries = DailyTrackingService.getMealEntriesForDate(
      _selectedDate!,
    );

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEntryForDateScreen(selectedDate: _selectedDate!),
                    ),
                  );

                  if (result == true) {
                    _loadCalendarData();
                    setState(() {});
                  }
                },
                icon: Icon(Icons.add, size: 16),
                label: Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size(0, 32),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          if (hasEntries) ...[
            // Macro summary row
            Row(
              children: [
                Expanded(
                  child: _buildMacroSummaryCard(
                    'Calories',
                    macros['calories']!,
                    'kcal',
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: _buildMacroSummaryCard(
                    'Protein',
                    macros['protein']!,
                    'g',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: _buildMacroSummaryCard(
                    'Carbs',
                    macros['carbs']!,
                    'g',
                    Colors.green,
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: _buildMacroSummaryCard(
                    'Fat',
                    macros['fat']!,
                    'g',
                    Colors.red,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Text(
              'Entries',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),

            // Entries list
            ...foodEntries.map((entry) => _buildFoodEntryCard(entry)).toList(),
            ...mealEntries.map((entry) => _buildMealEntryCard(entry)).toList(),
          ] else ...[
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No entries for this date',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFoodEntryCard(DailyFoodEntry entry) {
    final food = FoodDatabaseService.getFood(entry.foodId);
    if (food == null) return Container();

    final macros = food.getMacrosForGrams(entry.grams);
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(
                  '${entry.grams.toInt()}g • ${macros['calories']!.toInt()} cal',
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteEntry(entry.id, true),
            child: Icon(Icons.delete, size: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildMealEntryCard(DailyMealEntry entry) {
    final meal = FoodDatabaseService.getMeal(entry.mealId);
    if (meal == null) return Container();

    final macros = FoodDatabaseService.calculateMealMacrosForQuantity(
      meal,
      entry.multiplier,
    );
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(
                  '${entry.multiplier}x • ${macros['calories']!.toInt()} cal',
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteEntry(entry.id, false),
            child: Icon(Icons.delete, size: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _deleteEntry(String entryId, bool isFood) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Entry'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (isFood) {
        await DailyTrackingService.deleteFoodEntry(entryId);
      } else {
        await DailyTrackingService.deleteMealEntry(entryId);
      }
      _loadCalendarData();
      setState(() {});
    }
  }

  Widget _buildMacroSummaryCard(
    String label,
    double value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(unit, style: TextStyle(fontSize: 9, color: color)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getData() {
    switch (_selectedPeriod) {
      case 0: // 7 days
        return DailyTrackingService.getLastNDaysData(7);
      case 1: // Current week
        return DailyTrackingService.getCurrentWeekData();
      case 2: // 30 days
        return DailyTrackingService.getLastNDaysData(30);
      default:
        return DailyTrackingService.getCurrentWeekData();
    }
  }

  Color _getChartColor(int index) {
    final colors = [Colors.orange, Colors.blue, Colors.green, Colors.red];
    return colors[index];
  }

  String _getChartUnit(int index) {
    final units = ['kcal', 'g', 'g', 'g'];
    return units[index];
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}
