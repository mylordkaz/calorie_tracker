import 'package:flutter/material.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/stats_controller.dart';
import '../widgets/chart_section.dart';
import '../widgets/calendar_section.dart';
import '../widgets/day_details_section.dart';
import '../screens/add_entry_for_date_screen.dart';
import '../../../core/utils/localization_helper.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late final StatsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StatsController(
      foodRepository: RepositoryFactory.createFoodRepository(),
      trackingRepository: RepositoryFactory.createTrackingRepository(),
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
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.statistics),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart Section
                ChartSection(
                  selectedChart: _controller.selectedChart,
                  selectedPeriod: _controller.selectedPeriod,
                  chartData: _controller.chartData,
                  onChartChanged: _controller.onChartChanged,
                  onPeriodChanged: _controller.onPeriodChanged,
                ),

                SizedBox(height: 24),

                // Calendar Section
                CalendarSection(
                  currentMonth: _controller.currentCalendarMonth,
                  selectedDate: _controller.selectedDate,
                  datesWithEntries: _controller.datesWithEntries,
                  onDateSelected: _controller.onDateSelected,
                  onMonthChanged: _controller.onMonthChanged,
                ),

                SizedBox(height: 24),

                // Day Details Section
                DayDetailsSection(
                  selectedDate: _controller.selectedDate,
                  dayData: _controller.dayDetailsData,
                  onAddEntry: _navigateToAddEntry,
                  onDeleteEntry: _deleteEntry,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddEntry() async {
    if (_controller.selectedDate == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEntryForDateScreen(selectedDate: _controller.selectedDate!),
      ),
    );

    if (result == true) {
      await _controller.refresh();
    }
  }

  Future<void> _deleteEntry(String entryId, bool isFood) async {
    final l10n = L10n.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.confirmDeleteEntry),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _controller.deleteEntry(entryId, isFood);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.entryDeletedSuccessfully)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorDeletingEntry(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
