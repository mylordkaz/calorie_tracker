
import 'package:flutter/material.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../widgets/chart_section.dart';
import '../widgets/day_details_section.dart';

class StatsController extends ChangeNotifier {
  final FoodRepository _foodRepository;
  final TrackingRepository _trackingRepository;

  StatsController({
    required FoodRepository foodRepository,
    required TrackingRepository trackingRepository,
  }) : _foodRepository = foodRepository,
       _trackingRepository = trackingRepository;

  // Chart state
  int _selectedChart = 0;
  int _selectedPeriod = 1; // 0: 7 days, 1: Current Week, 2: 30 days
  List<ChartData> _chartData = [];

  // Calendar state
  DateTime _currentCalendarMonth = DateTime.now();
  DateTime? _selectedDate;
  List<DateTime> _datesWithEntries = [];

  // Day details state
  DayDetailsData? _dayDetailsData;

  // Loading state
  bool _isLoading = true;

  // Getters
  int get selectedChart => _selectedChart;
  int get selectedPeriod => _selectedPeriod;
  List<ChartData> get chartData => _chartData;
  DateTime get currentCalendarMonth => _currentCalendarMonth;
  DateTime? get selectedDate => _selectedDate;
  List<DateTime> get datesWithEntries => _datesWithEntries;
  DayDetailsData? get dayDetailsData => _dayDetailsData;
  bool get isLoading => _isLoading;

  // Initialize data
  Future<void> loadData() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _loadChartData();
      await _loadCalendarData();
      if (_selectedDate != null) {
        await _loadDayDetailsData();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading stats data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Chart methods
  void onChartChanged(int index) {
    _selectedChart = index;
    notifyListeners();
  }

  Future<void> onPeriodChanged(int period) async {
    _selectedPeriod = period;
    await _loadChartData();
    notifyListeners();
  }

  // Calendar methods
  Future<void> onDateSelected(DateTime date) async {
    _selectedDate = date;
    await _loadDayDetailsData();
    notifyListeners();
  }

  Future<void> onMonthChanged(DateTime newMonth) async {
    _currentCalendarMonth = newMonth;
    await _loadCalendarData();
    notifyListeners();
  }

  // Entry management
  Future<void> deleteEntry(String entryId, bool isFood) async {
    try {
      if (isFood) {
        await _trackingRepository.deleteFoodEntry(entryId);
      } else {
        await _trackingRepository.deleteMealEntry(entryId);
      }

      // Refresh relevant data
      await _loadCalendarData();
      if (_selectedDate != null) {
        await _loadDayDetailsData();
      }
      await _loadChartData();

      notifyListeners();
    } catch (e) {
      print('Error deleting entry: $e');
      rethrow;
    }
  }

  // Private methods
  Future<void> _loadChartData() async {
    List<Map<String, dynamic>> rawData;

    switch (_selectedPeriod) {
      case 0: // 7 days
        rawData = _trackingRepository.getLastNDaysData(7);
        break;
      case 1: // Current week
        rawData = _trackingRepository.getCurrentWeekData();
        break;
      case 2: // 30 days
        rawData = _trackingRepository.getLastNDaysData(30);
        break;
      default:
        rawData = _trackingRepository.getCurrentWeekData();
    }

    _chartData = rawData.map((dayData) {
      final date = dayData['date'] as DateTime;
      final macros = dayData['macros'] as Map<String, double>;

      return ChartData(
        date: date,
        macros: macros,
        dateLabel: '${date.day}/${date.month}',
      );
    }).toList();
  }

  Future<void> _loadCalendarData() async {
    _datesWithEntries = _trackingRepository.getDatesWithEntriesForMonth(
      _currentCalendarMonth.year,
      _currentCalendarMonth.month,
    );
  }

  Future<void> _loadDayDetailsData() async {
    if (_selectedDate == null) {
      _dayDetailsData = null;
      return;
    }

    final macros = _trackingRepository.getMacrosForDate(_selectedDate!);
    final foodEntries = _trackingRepository.getFoodEntriesForDate(
      _selectedDate!,
    );
    final mealEntries = _trackingRepository.getMealEntriesForDate(
      _selectedDate!,
    );

    // Process food entries
    List<FoodEntryData> processedFoodEntries = [];
    for (var entry in foodEntries) {
      String name;
      String subtitle;

      if (entry.isQuickEntry) {
        name = entry.quickEntryName!;
        final calories = entry.quickEntryCalories ?? 0.0;
        subtitle =
            '${entry.grams.toInt()}g • ${calories.toInt()} cal (quick entry)';
      } else if (entry.foodId != null) {
        final food = _foodRepository.getFood(entry.foodId!);
        if (food != null) {
          name = food.name;
          final entryMacros = food.getMacrosForGrams(entry.grams);
          final calories = entryMacros['calories']!;
          subtitle = '${entry.grams.toInt()}g • ${calories.toInt()} cal';
        } else {
          continue; // Skip if food not found
        }
      } else {
        continue; // Skip invalid entries
      }

      final timeStr =
          '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

      processedFoodEntries.add(
        FoodEntryData(
          id: entry.id,
          name: name,
          subtitle: subtitle,
          timeStr: timeStr,
        ),
      );
    }

    // Process meal entries
    List<MealEntryData> processedMealEntries = [];
    for (var entry in mealEntries) {
      final meal = _foodRepository.getMeal(entry.mealId);
      if (meal != null) {
        final mealMacros = _foodRepository.calculateMealMacrosForQuantity(
          meal,
          entry.multiplier,
        );
        final timeStr =
            '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

        processedMealEntries.add(
          MealEntryData(
            id: entry.id,
            name: meal.name,
            subtitle:
                '${entry.multiplier}x serving • ${mealMacros['calories']!.toInt()} cal',
            timeStr: timeStr,
          ),
        );
      }
    }

    _dayDetailsData = DayDetailsData(
      calories: macros['calories']!,
      protein: macros['protein']!,
      carbs: macros['carbs']!,
      fat: macros['fat']!,
      totalEntries: processedFoodEntries.length + processedMealEntries.length,
      foodEntries: processedFoodEntries,
      mealEntries: processedMealEntries,
    );
  }

  // Refresh after returning from add entry screen
  Future<void> refresh() async {
    await loadData();
  }
}
