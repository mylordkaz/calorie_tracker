import 'package:flutter/material.dart';
import '../../../data/repositories/repository_factory.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/home_controller.dart';
import '../widgets/calorie_progress_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/target_dialog.dart';
import 'add_food_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(
      foodRepository: RepositoryFactory.createFoodRepository(),
      trackingRepository: RepositoryFactory.createTrackingRepository(),
      settingsRepository: RepositoryFactory.createSettingsRepository(),
    );
    _controller.loadData();
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
        title: Text(AppConstants.appName),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: _showTargetDialog),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopSection(),
                SizedBox(height: 16),
                _buildMiddleSection(),
                SizedBox(height: 16),
                _buildBottomSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopSection() {
    return CalorieProgressCard(
      currentCalories: _controller.currentCalories,
      dailyTarget: _controller.dailyTarget,
      currentMacros: _controller.currentMacros,
      onAddFood: _navigateToAddFood,
      onSetTarget: _showTargetDialog,
    );
  }

  Widget _buildMiddleSection() {
    final todayEntries = _controller.getTodayEntries();

    return QuickActionsSection(
      todayEntries: todayEntries,
      onCopyYesterday: _copyFromYesterday,
      onViewAllEntries: () => _showFullTodaysLog(todayEntries),
    );
  }

  Widget _buildBottomSection() {
    return QuickStatsCard(
      weeklyAverage: _controller.weeklyAverage,
      yesterdayCalories: _controller.yesterdayCalories,
      dailyTarget: _controller.dailyTarget,
      currentCalories: _controller.currentCalories,
    );
  }

  Future<void> _navigateToAddFood() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodEntryScreen()),
    );
    if (result == true) {
      _controller.refresh();
    }
  }

  Future<void> _showTargetDialog() async {
    final target = await TargetDialog.show(
      context,
      currentTarget: _controller.dailyTarget,
    );

    if (target != null) {
      await _controller.setDailyTarget(target);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Daily target updated to ${target.toInt()} calories'),
          ),
        );
      }
    }
  }

  Future<void> _copyFromYesterday() async {
    try {
      await _controller.copyFromYesterday();
      if (mounted) {
        final todayEntries = _controller.getTodayEntries();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Copied ${todayEntries.length} entries from yesterday',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  void _showFullTodaysLog(List<Map<String, dynamic>> allEntries) {
    showDialog(
      context: context,
      builder: (context) => _FullLogDialog(entries: allEntries),
    );
  }
}

class _FullLogDialog extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const _FullLogDialog({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return _buildFullLogEntryItem(entries[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullLogEntryItem(Map<String, dynamic> item) {
    final isFood = item['type'] == 'food';
    final calories = item['calories'] as double;
    final timestamp = item['timestamp'] as DateTime;

    final name = item['name'] as String;
    final subtitle = item['subtitle'] as String;
    final icon = isFood ? Icons.restaurant : Icons.local_dining;
    final iconColor = isFood ? Colors.blue : Colors.grey[600]!;

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
}
