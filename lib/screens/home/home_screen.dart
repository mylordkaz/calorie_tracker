import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/common/stat_card.dart';
import '../../services/user_settings_service.dart';
import '../../services/daily_tracking_service.dart';
import '../../services/food_database_service.dart';
import '../../models/food_item.dart';
import '../../models/meal.dart';
import '../../models/daily_entry.dart';
import 'add_food_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _dailyTarget;
  double _currentCalories = 0;
  Map<String, double> _currentMacros = {'protein': 0, 'carbs': 0, 'fat': 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      if (UserSettingsService.isInitialized) {
        setState(() {
          _dailyTarget = UserSettingsService.getDailyCalorieTarget();
          _currentCalories = DailyTrackingService.getTodayCalories();
          _currentMacros = _calculateTodayMacros();
          _isLoading = false;
        });
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        _loadData();
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, double> _calculateTodayMacros() {
    Map<String, double> totalMacros = {'protein': 0, 'carbs': 0, 'fat': 0};

    // Get today's food entries
    final foodEntries = DailyTrackingService.getTodayFoodEntries();
    for (var entry in foodEntries) {
      if (entry.isQuickEntry) {
        final macros = entry.getMacros();
        totalMacros['protein'] = totalMacros['protein']! + macros['protein']!;
        totalMacros['carbs'] = totalMacros['carbs']! + macros['carbs']!;
        totalMacros['fat'] = totalMacros['fat']! + macros['fat']!;
      } else if (entry.foodId != null) {
        final food = FoodDatabaseService.getFood(entry.foodId!);
        if (food != null) {
          final macros = food.getMacrosForGrams(entry.grams);
          totalMacros['protein'] = totalMacros['protein']! + macros['protein']!;
          totalMacros['carbs'] = totalMacros['carbs']! + macros['carbs']!;
          totalMacros['fat'] = totalMacros['fat']! + macros['fat']!;
        }
      }
    }

    // Get today's meal entries
    final mealEntries = DailyTrackingService.getTodayMealEntries();
    for (var entry in mealEntries) {
      final meal = FoodDatabaseService.getMeal(entry.mealId);
      if (meal != null) {
        final mealMacros = FoodDatabaseService.calculateMealMacros(meal);
        totalMacros['protein'] =
            totalMacros['protein']! +
            (mealMacros['protein']! * entry.multiplier);
        totalMacros['carbs'] =
            totalMacros['carbs']! + (mealMacros['carbs']! * entry.multiplier);
        totalMacros['fat'] =
            totalMacros['fat']! + (mealMacros['fat']! * entry.multiplier);
      }
    }

    return totalMacros;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Calorie Tracker'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    final progress = _dailyTarget != null
        ? _currentCalories / _dailyTarget!
        : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: _showTargetDialog),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(progress),
            SizedBox(height: 16),
            _buildMiddleSection(context),
            SizedBox(height: 16),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(double progress) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
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
                onTap: _showTargetDialog,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _dailyTarget != null
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _dailyTarget != null
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _dailyTarget != null
                        ? 'Target: ${_dailyTarget!.toInt()}'
                        : 'Set Target',
                    style: TextStyle(
                      fontSize: 11,
                      color: _dailyTarget != null
                          ? Colors.blue
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),

          Container(
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
                      _dailyTarget != null
                          ? (progress <= 1.0 ? Colors.blue : Colors.grey[600]!)
                          : Colors.grey[400]!,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_currentCalories.toInt()}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _dailyTarget != null
                          ? 'of ${_dailyTarget!.toInt()}'
                          : 'calories',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    if (_dailyTarget != null)
                      Text(
                        'calories',
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 14),

          // Macros row
          Text(
            'Protein: ${_currentMacros['protein']!.toInt()}g • Carbs: ${_currentMacros['carbs']!.toInt()}g • Fat: ${_currentMacros['fat']!.toInt()}g',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 14),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFoodEntryScreen(),
                    ),
                  );
                  if (result == true) {
                    _loadData();
                  }
                },
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
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),

        // Recent items
        _buildTodaysLog(),
        SizedBox(height: 8),

        // Copy from yesterday button
        _buildCopyYesterdayButton(),
      ],
    );
  }

  Widget _buildTodaysLog() {
    final todayFoodEntries = DailyTrackingService.getTodayFoodEntries();
    final todayMealEntries = DailyTrackingService.getTodayMealEntries();

    final totalEntries = todayFoodEntries.length + todayMealEntries.length;

    if (totalEntries == 0) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(Icons.restaurant_menu, size: 24, color: Colors.grey[400]),
            SizedBox(height: 6),
            Text(
              'No entries logged today yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Tap "Add Food" to start tracking',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    // Combine and sort all entries by timestamp (newest first)
    List<Map<String, dynamic>> allEntries = [];

    for (var entry in todayFoodEntries) {
      double calories;
      FoodItem? food;

      if (entry.isQuickEntry) {
        calories = entry.getCalories();
      } else if (entry.foodId != null) {
        food = FoodDatabaseService.getFood(entry.foodId!);
        if (food != null) {
          calories = food.getCaloriesForGrams(entry.grams);
        } else {
          continue; // Skip if food not found
        }
      } else {
        continue; // Skip invalid entries
      }

      allEntries.add({
        'type': 'food',
        'entry': entry,
        'food': food, // Can be null for quick entries
        'calories': calories,
        'timestamp': entry.timestamp,
      });
    }

    for (var entry in todayMealEntries) {
      final meal = FoodDatabaseService.getMeal(entry.mealId);
      if (meal != null) {
        final mealMacros = FoodDatabaseService.calculateMealMacros(meal);
        final calories = (mealMacros['calories'] ?? 0.0) * entry.multiplier;
        allEntries.add({
          'type': 'meal',
          'entry': entry,
          'meal': meal,
          'calories': calories,
          'timestamp': entry.timestamp,
        });
      }
    }

    // Sort by timestamp (newest first)
    allEntries.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    // Show mini list (first 4 items)
    final miniList = allEntries.take(4).toList();
    final hasMore = allEntries.length > 4;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Log',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (hasMore)
                GestureDetector(
                  onTap: () => _showFullTodaysLog(allEntries),
                  child: Text(
                    'View All (${allEntries.length})',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          ...miniList.map((item) => _buildLogEntryItem(item)),
        ],
      ),
    );
  }

  Widget _buildLogEntryItem(Map<String, dynamic> item) {
    final isFood = item['type'] == 'food';
    final calories = item['calories'] as double;

    String name;
    String subtitle;
    IconData icon;
    Color iconColor;

    if (isFood) {
      final entry = item['entry'] as DailyFoodEntry;

      if (entry.isQuickEntry) {
        name = entry.quickEntryName!;
        subtitle = '${entry.grams.toInt()}g (quick entry)';
      } else {
        final food = item['food'] as FoodItem;
        name = food.name;

        if (entry.originalQuantity != null && entry.originalUnit != null) {
          subtitle =
              '${entry.originalQuantity!.toStringAsFixed(entry.originalQuantity! % 1 == 0 ? 0 : 1)} ${entry.originalUnit}';
        } else {
          subtitle = '${entry.grams.toInt()}g';
        }
      }

      icon = Icons.restaurant;
      iconColor = Colors.blue;
    } else {
      final meal = item['meal'] as Meal;
      final entry = item['entry'] as DailyMealEntry;
      name = meal.name;
      subtitle =
          '${entry.multiplier.toStringAsFixed(entry.multiplier % 1 == 0 ? 0 : 1)}x serving';
      icon = Icons.local_dining;
      iconColor = Colors.grey[600]!;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '${calories.toInt()} cal',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullTodaysLog(List<Map<String, dynamic>> allEntries) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Complete Log',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: allEntries.length,
                  itemBuilder: (context, index) {
                    return _buildFullLogEntryItem(allEntries[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullLogEntryItem(Map<String, dynamic> item) {
    final isFood = item['type'] == 'food';
    final calories = item['calories'] as double;
    final timestamp = item['timestamp'] as DateTime;

    String name;
    String subtitle;
    IconData icon;
    Color iconColor;

    if (isFood) {
      final entry = item['entry'] as DailyFoodEntry;

      if (entry.isQuickEntry) {
        name = entry.quickEntryName!;
        subtitle = '${entry.grams.toInt()}g (quick entry)';
      } else {
        final food = item['food'] as FoodItem;
        name = food.name;

        if (entry.originalQuantity != null && entry.originalUnit != null) {
          subtitle =
              '${entry.originalQuantity!.toStringAsFixed(entry.originalQuantity! % 1 == 0 ? 0 : 1)} ${entry.originalUnit}';
        } else {
          subtitle = '${entry.grams.toInt()}g';
        }
      }

      icon = Icons.restaurant;
      iconColor = Colors.blue;
    } else {
      final meal = item['meal'] as Meal;
      final entry = item['entry'] as DailyMealEntry;
      name = meal.name;
      subtitle =
          '${entry.multiplier.toStringAsFixed(entry.multiplier % 1 == 0 ? 0 : 1)}x serving';
      icon = Icons.local_dining;
      iconColor = Colors.grey[600]!;
    }

    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${calories.toInt()} cal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                timeStr,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCopyYesterdayButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _copyFromYesterday,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.copy, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Copy from Yesterday',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Add all yesterday\'s entries to today',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    final weeklyAverage = DailyTrackingService.getWeeklyAverageCalories();
    final yesterdayCalories = DailyTrackingService.getYesterdayCalories();

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
                value: _dailyTarget != null
                    ? '${(_dailyTarget! - _currentCalories).toInt()}'
                    : '--',
                unit: 'calories',
                color: Colors.blue[300]!,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: StatCard(
                title: 'Progress',
                value: _dailyTarget != null
                    ? '${((_currentCalories / _dailyTarget!) * 100).toInt()}'
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

  void _copyFromYesterday() async {
    // Get yesterday's entries using public methods
    final allFoodEntries = DailyTrackingService.getYesterdayFoodEntries();
    final allMealEntries = DailyTrackingService.getYesterdayMealEntries();

    if (allFoodEntries.isEmpty && allMealEntries.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No entries found for yesterday')));
      return;
    }

    // Copy food entries
    for (var entry in allFoodEntries) {
      if (entry.isQuickEntry) {
        // Copy as quick entry
        await DailyTrackingService.addQuickFoodEntry(
          name: entry.quickEntryName!,
          calories: entry.quickEntryCalories ?? 0.0,
          protein: entry.quickEntryProtein ?? 0.0,
          carbs: entry.quickEntryCarbs ?? 0.0,
          fat: entry.quickEntryFat ?? 0.0,
        );
      } else if (entry.foodId != null) {
        // Copy as regular food entry
        await DailyTrackingService.addFoodEntry(
          foodId: entry.foodId!,
          grams: entry.grams,
          originalQuantity: entry.originalQuantity,
          originalUnit: entry.originalUnit,
        );
      }
    }

    // Copy meal entries
    for (var entry in allMealEntries) {
      await DailyTrackingService.addMealEntry(
        mealId: entry.mealId,
        multiplier: entry.multiplier,
      );
    }

    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied ${allFoodEntries.length + allMealEntries.length} entries from yesterday',
        ),
      ),
    );
  }

  void _showTargetDialog() {
    final controller = TextEditingController(
      text: _dailyTarget != null ? _dailyTarget!.toInt().toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Set Daily Calorie Target',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Daily Calorie Target',
                suffixText: 'calories',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final target = double.tryParse(controller.text);
              if (target != null && target > 0) {
                await UserSettingsService.setDailyCalorieTarget(target);
                setState(() {
                  _dailyTarget = target;
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Daily target updated to ${target.toInt()} calories',
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
