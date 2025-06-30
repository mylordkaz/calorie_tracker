import 'package:flutter/material.dart';
import 'custom_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;

  const StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
