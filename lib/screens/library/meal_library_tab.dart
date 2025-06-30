import 'package:flutter/material.dart';
import '../../widgets/common/custom_card.dart';

class MealLibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomCard(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_dining_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'Meal Library',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Build custom meals from your food library',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
