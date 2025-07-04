import 'package:flutter/material.dart';

class TodaysLogCard extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final VoidCallback? onViewAll;

  const TodaysLogCard({Key? key, required this.entries, this.onViewAll})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _buildEmptyState();
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
          _buildHeader(hasMore),
          SizedBox(height: 8),
          ...miniList.map((item) => _buildLogEntryItem(item)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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

  Widget _buildHeader(bool hasMore) {
    return Row(
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
        if (hasMore && onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'View All (${entries.length})',
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

  Widget _buildLogEntryItem(Map<String, dynamic> item) {
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
}
