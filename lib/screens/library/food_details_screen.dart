import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/food_item.dart';
import '../../services/food_database_service.dart';
import '../../widgets/common/custom_card.dart';
import 'add_food_screen.dart';

class FoodDetailsScreen extends StatelessWidget {
  final FoodItem food;

  const FoodDetailsScreen({required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(food.name),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => _editFood(context),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _showDeleteConfirmation(context),
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (food.imagePath != null && File(food.imagePath!).existsSync())
              CustomCard(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(food.imagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            if (food.imagePath != null && File(food.imagePath!).existsSync())
              SizedBox(height: 16),

            // Basic Info Section
            _buildSection('Basic Information', [
              _buildInfoRow('Name', food.name),
              if (food.description.isNotEmpty)
                _buildInfoRow('Description', food.description),
              _buildInfoRow('Unit Type', food.getDisplayUnit()),
              if (food.unitWeight != null)
                _buildInfoRow('Unit Weight', '${food.unitWeight!.toInt()}g'),
            ]),

            SizedBox(height: 16),

            // Nutrition Section
            _buildSection('Nutrition Facts (${food.getDisplayUnit()})', [
              Row(
                children: [
                  Expanded(
                    child: _buildMacroCard(
                      'Calories',
                      food.calories,
                      'kcal',
                      Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroCard(
                      'Protein',
                      food.protein,
                      'g',
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMacroCard(
                      'Carbs',
                      food.carbs,
                      'g',
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroCard('Fat', food.fat, 'g', Colors.red),
                  ),
                ],
              ),

              // Custom Macros
              if (food.customMacros != null &&
                  food.customMacros!.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(
                  'Additional Nutrients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                ...food.customMacros!.entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _buildMacroCard(
                      entry.key.toString(),
                      entry.value,
                      'g',
                      Colors.purple,
                    ),
                  ),
                ),
              ],
            ]),

            SizedBox(height: 16),

            // Usage Stats Section
            _buildSection('Usage Statistics', [
              _buildInfoRow('Times Used', food.useCount.toString()),
              _buildInfoRow('Last Used', _formatDate(food.lastUsed)),
              _buildInfoRow('Created', _formatDate(food.createdAt)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, double value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(unit, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editFood(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen(foodToEdit: food)),
    );
    if (result == true) {
      Navigator.pop(context, true); // Return to library with refresh signal
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Food'),
        content: Text('Are you sure you want to delete "${food.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FoodDatabaseService.deleteFood(food.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(
                context,
                true,
              ); // Return to library with refresh signal
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
