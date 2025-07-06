import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../core/utils/localization_helper.dart';
import 'macro_card.dart';
import 'food_entry_card.dart';
import 'meal_entry_card.dart';

class DayDetailsSection extends StatelessWidget {
  final DateTime? selectedDate;
  final DayDetailsData? dayData;
  final VoidCallback onAddEntry;
  final Function(String, bool) onDeleteEntry;

  const DayDetailsSection({
    Key? key,
    required this.selectedDate,
    required this.dayData,
    required this.onAddEntry,
    required this.onDeleteEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return _buildEmptyState(context);
    }

    if (dayData == null || !dayData!.hasEntries) {
      return _buildSelectedDayWithoutEntries(context);
    }

    return _buildSelectedDayWithEntries(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = L10n.of(context);

    return CustomCard(
      child: Container(
        width: double.infinity,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 32,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Text(
              l10n.selectDateToViewDetails,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              l10n.tapOnAnyDayInCalendar,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayWithoutEntries(BuildContext context) {
    final l10n = L10n.of(context);

    return CustomCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    l10n.noEntriesYet,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              _buildAddButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayWithEntries(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      children: [
        // Header Card
        CustomCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${dayData!.totalEntries} ${l10n.entriesLogged}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  _buildAddButton(context),
                ],
              ),

              SizedBox(height: 20),
              // Macro Cards Grid
              Row(
                children: [
                  Expanded(
                    child: MacroCard(
                      label: l10n.calories,
                      value: dayData!.calories,
                      unit: l10n.kcal,
                      color: Colors.orange,
                      icon: Icons.local_fire_department,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: MacroCard(
                      label: l10n.protein,
                      value: dayData!.protein,
                      unit: 'g',
                      color: Colors.blue,
                      icon: Icons.fitness_center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: MacroCard(
                      label: l10n.carbs,
                      value: dayData!.carbs,
                      unit: 'g',
                      color: Colors.green,
                      icon: Icons.grass,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: MacroCard(
                      label: l10n.fat,
                      value: dayData!.fat,
                      unit: 'g',
                      color: Colors.amber,
                      icon: Icons.opacity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Entries Card
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.foodLog,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              ...dayData!.foodEntries.map((entry) {
                return FoodEntryCard(
                  name: entry.name,
                  subtitle: entry.subtitle,
                  timeStr: entry.timeStr,
                  onDelete: () => onDeleteEntry(entry.id, true),
                );
              }).toList(),
              ...dayData!.mealEntries.map((entry) {
                return MealEntryCard(
                  name: entry.name,
                  subtitle: entry.subtitle,
                  timeStr: entry.timeStr,
                  onDelete: () => onDeleteEntry(entry.id, false),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final l10n = L10n.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAddEntry,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  l10n.addEntry,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data classes to pass processed data
class DayDetailsData {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final int totalEntries;
  final List<FoodEntryData> foodEntries;
  final List<MealEntryData> mealEntries;

  DayDetailsData({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.totalEntries,
    required this.foodEntries,
    required this.mealEntries,
  });

  bool get hasEntries => totalEntries > 0;
}

class FoodEntryData {
  final String id;
  final String name;
  final String subtitle;
  final String timeStr;

  FoodEntryData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.timeStr,
  });
}

class MealEntryData {
  final String id;
  final String name;
  final String subtitle;
  final String timeStr;

  MealEntryData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.timeStr,
  });
}
