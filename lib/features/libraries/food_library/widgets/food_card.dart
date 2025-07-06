import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../data/models/food_item.dart';
import '../../../../l10n/app_localizations.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const FoodCard({Key? key, required this.food, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String calorieDisplay;
    String proteinDisplay;
    String unitDisplay;

    switch (food.unit) {
      case 'item':
        calorieDisplay = '${food.calories.toInt()} ${l10n.cal}';
        proteinDisplay =
            '${food.protein.toStringAsFixed(1)}g ${l10n.protein.toLowerCase()}';
        unitDisplay = l10n.perItem;
        break;
      case 'serving':
        calorieDisplay = '${food.calories.toInt()} ${l10n.cal}';
        proteinDisplay =
            '${food.protein.toStringAsFixed(1)}g ${l10n.protein.toLowerCase()}';
        unitDisplay = l10n.perServing;
        break;
      case '100g':
      default:
        calorieDisplay = '${food.calories.toInt()} ${l10n.cal}';
        proteinDisplay =
            '${food.protein.toStringAsFixed(1)}g ${l10n.protein.toLowerCase()}';
        unitDisplay = l10n.per100g;
        break;
    }

    final hasImage =
        food.imagePath != null && File(food.imagePath!).existsSync();

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Image - only show if exists
                  if (hasImage) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(food.imagePath!),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          food.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if (food.description.isNotEmpty) ...[
                          SizedBox(height: 2),
                          Text(
                            food.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        SizedBox(height: 6),

                        // Flexible macro chips
                        Flexible(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _buildMacroChip(calorieDisplay, Colors.orange),
                              _buildMacroChip(proteinDisplay, Colors.blue),
                              _buildUnitChip(unitDisplay, food.unit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUnitChip(String text, String unit) {
    IconData icon;
    Color color;

    switch (unit) {
      case 'item':
        icon = Icons.egg;
        color = Colors.purple;
        break;
      case 'serving':
        icon = Icons.local_dining;
        color = Colors.teal;
        break;
      case '100g':
      default:
        icon = Icons.straighten;
        color = Colors.grey[600]!;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
