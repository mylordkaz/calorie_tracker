import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../core/utils/localization_helper.dart';

class CalendarSection extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime? selectedDate;
  final List<DateTime> datesWithEntries;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const CalendarSection({
    Key? key,
    required this.currentMonth,
    required this.selectedDate,
    required this.datesWithEntries,
    required this.onDateSelected,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(context, currentMonth.month)} ${currentMonth.year}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      onMonthChanged(
                        DateTime(currentMonth.year, currentMonth.month - 1),
                      );
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: () {
                      onMonthChanged(
                        DateTime(currentMonth.year, currentMonth.month + 1),
                      );
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
            children:
                [
                      l10n.monday,
                      l10n.tuesday,
                      l10n.wednesday,
                      l10n.thursday,
                      l10n.friday,
                      l10n.saturday,
                      l10n.sunday,
                    ]
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
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7
    final daysInMonth = lastDayOfMonth.day;

    // Calculate previous month info
    final prevMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    final lastDayOfPrevMonth = DateTime(
      prevMonth.year,
      prevMonth.month + 1,
      0,
    ).day;

    List<Widget> calendarDays = [];

    // Add gray days from previous month
    for (int i = firstDayWeekday - 1; i > 0; i--) {
      final day = lastDayOfPrevMonth - i + 1;
      final date = DateTime(prevMonth.year, prevMonth.month, day);

      calendarDays.add(
        GestureDetector(
          onTap: () {
            onMonthChanged(DateTime(prevMonth.year, prevMonth.month));
            onDateSelected(date);
          },
          child: Container(
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
        ),
      );
    }

    // Add days of current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final hasEntries = datesWithEntries.any(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );
      final isSelected =
          selectedDate != null &&
          selectedDate!.year == date.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day;
      final isToday =
          DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      calendarDays.add(
        GestureDetector(
          onTap: () => onDateSelected(date),
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
                  ? Border.all(color: Colors.blue, width: 1.5)
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
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);

    while (calendarDays.length % 7 != 0) {
      final date = DateTime(nextMonth.year, nextMonth.month, nextMonthDay);

      calendarDays.add(
        GestureDetector(
          onTap: () {
            onMonthChanged(DateTime(nextMonth.year, nextMonth.month));
            onDateSelected(date);
          },
          child: Container(
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

  String _getMonthName(BuildContext context, int month) {
    final l10n = L10n.of(context);

    switch (month) {
      case 1:
        return l10n.january;
      case 2:
        return l10n.february;
      case 3:
        return l10n.march;
      case 4:
        return l10n.april;
      case 5:
        return l10n.may;
      case 6:
        return l10n.june;
      case 7:
        return l10n.july;
      case 8:
        return l10n.august;
      case 9:
        return l10n.september;
      case 10:
        return l10n.october;
      case 11:
        return l10n.november;
      case 12:
        return l10n.december;
      default:
        return '';
    }
  }
}
