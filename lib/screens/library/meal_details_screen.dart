import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/meal.dart';
import '../../models/food_item.dart';
import '../../services/food_database_service.dart';
import '../../widgets/common/custom_card.dart';
import 'add_meal_screen.dart';

class MealDetailsScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailsScreen({required this.meal});

  @override
  Widget build(BuildContext context) {
    final macros = FoodDatabaseService.calculateMealMacros(meal);
    final totalWeight = meal.getTotalWeight();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(meal.name),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => _editMeal(context),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _showDeleteConfirmation(context),
            icon: Icon(Icons.delete, color: Colors.red),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      meal.isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'favorite') {
                _toggleFavorite(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meal.imagePath != null &&
                File(meal.imagePath!).existsSync()) ...[
              CustomCard(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(meal.imagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
            // Basic Info Section
            _buildSection('Meal Information', [
              _buildInfoRow('Name', meal.name),
              if (meal.description.isNotEmpty)
                _buildInfoRow('Description', meal.description),
              if (meal.category != null)
                _buildInfoRow('Category', meal.category!),
              _buildInfoRow('Total Weight', '${totalWeight.toInt()}g'),
              _buildInfoRow('Ingredients', '${meal.getIngredientCount()}'),
            ]),

            SizedBox(height: 16),

            // Nutrition Section
            _buildSection('Nutrition Facts (Total)', [
              Row(
                children: [
                  Expanded(
                    child: _buildMacroCard(
                      'Calories',
                      macros['calories']!,
                      'kcal',
                      Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroCard(
                      'Protein',
                      macros['protein']!,
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
                      macros['carbs']!,
                      'g',
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroCard(
                      'Fat',
                      macros['fat']!,
                      'g',
                      Colors.red,
                    ),
                  ),
                ],
              ),
            ]),

            SizedBox(height: 16),

            // Ingredients Section
            _buildSection('Ingredients', [
              ...meal.ingredients.map((ingredient) {
                final food = FoodDatabaseService.getFood(ingredient.foodId);
                if (food == null) {
                  return _buildMissingIngredientCard(ingredient);
                }
                return _buildIngredientCard(ingredient, food);
              }).toList(),
            ]),

            SizedBox(height: 16),

            // Usage Stats Section
            _buildSection('Usage Statistics', [
              _buildInfoRow('Times Used', meal.useCount.toString()),
              _buildInfoRow('Last Used', _formatDate(meal.lastUsed)),
              _buildInfoRow('Created', _formatDate(meal.createdAt)),
              if (meal.isFavorite) _buildInfoRow('Status', '⭐ Favorite'),
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

  Widget _buildIngredientCard(MealIngredient ingredient, FoodItem food) {
    final macros = ingredient.calculateMacros(food);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      ingredient.getDisplayQuantity(food),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                '${ingredient.grams.toInt()}g',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildSmallMacroChip(
                '${macros['calories']!.toInt()} cal',
                Colors.orange,
              ),
              _buildSmallMacroChip(
                '${macros['protein']!.toStringAsFixed(1)}g protein',
                Colors.blue,
              ),
              _buildSmallMacroChip(
                '${macros['carbs']!.toStringAsFixed(1)}g carbs',
                Colors.green,
              ),
              _buildSmallMacroChip(
                '${macros['fat']!.toStringAsFixed(1)}g fat',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissingIngredientCard(MealIngredient ingredient) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Missing Food Item',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Food ID: ${ingredient.foodId}',
                  style: TextStyle(color: Colors.red[300], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMacroChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editMeal(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMealScreen(mealToEdit: meal)),
    );
    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  void _toggleFavorite(BuildContext context) async {
    await FoodDatabaseService.toggleMealFavorite(meal.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            meal.isFavorite ? 'Added to favorites' : 'Removed from favorites',
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Meal'),
        content: Text('Are you sure you want to delete "${meal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FoodDatabaseService.deleteMeal(meal.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                  context,
                  true,
                ); // Return to library with refresh signal
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
