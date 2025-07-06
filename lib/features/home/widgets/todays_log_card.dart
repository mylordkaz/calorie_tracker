import 'package:flutter/material.dart';
import '../../../core/utils/localization_helper.dart';

class TodaysLogCard extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final VoidCallback? onViewAll;

  const TodaysLogCard({Key? key, required this.entries, this.onViewAll})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    final miniList = entries.take(4).toList();
    final hasMore = entries.length > 4;

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
          _buildHeader(context, hasMore),
          SizedBox(height: 8),
          ...miniList.map((item) => _buildLogEntryItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = L10n.of(context);

    return Container(
      width: double.infinity,
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
            l10n.noEntriesLoggedYet,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            l10n.tapAddFoodToStart,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool hasMore) {
    final l10n = L10n.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.todaysLog,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (hasMore && onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              '${l10n.viewAll} (${entries.length})',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLogEntryItem(BuildContext context, Map<String, dynamic> item) {
    final l10n = L10n.of(context);
    final isFood = item['type'] == 'food';
    final calories = item['calories'] as double;

    String name;
    String subtitle;
    IconData icon;
    Color iconColor;

    if (isFood) {
      name = item['name'] as String;
      subtitle = item['subtitle'] as String;
      icon = Icons.restaurant;
      iconColor = Colors.blue;
    } else {
      name = item['name'] as String;
      subtitle = item['subtitle'] as String;
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
            '${calories.toInt()} ${l10n.cal}',
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
}
