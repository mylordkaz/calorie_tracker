import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/food_database_service.dart';
import '../../models/food_item.dart';
import '../../widgets/common/custom_card.dart';
import 'add_food_screen.dart';
import 'food_details_screen.dart';

class FoodLibraryTab extends StatefulWidget {
  @override
  _FoodLibraryTabState createState() => _FoodLibraryTabState();
}

class _FoodLibraryTabState extends State<FoodLibraryTab> {
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFoods() {
    setState(() {
      _foods = FoodDatabaseService.getAllFoods();
      _filteredFoods = _foods;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _filteredFoods = FoodDatabaseService.searchFoods(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            child: CustomCard(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search foods...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Foods List
          Expanded(
            child: _filteredFoods.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      return _buildFoodCard(food);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddFood(),
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    String calorieDisplay;
    String proteinDisplay;
    String unitDisplay;

    switch (food.unit) {
      case 'item':
        calorieDisplay = '${food.calories.toInt()} cal';
        proteinDisplay = '${food.protein.toStringAsFixed(1)}g protein';
        unitDisplay = 'per item';
        break;
      case 'serving':
        calorieDisplay = '${food.calories.toInt()} cal';
        proteinDisplay = '${food.protein.toStringAsFixed(1)}g protein';
        unitDisplay = 'per serving';
        break;
      case '100g':
      default:
        calorieDisplay = '${food.calories.toInt()} cal';
        proteinDisplay = '${food.protein.toStringAsFixed(1)}g protein';
        unitDisplay = 'per 100g';
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: food.imagePath != null && File(food.imagePath!).existsSync()
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(food.imagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          title: Text(
            food.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (food.description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    food.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildMacroChip(calorieDisplay, Colors.orange),
                  _buildMacroChip(proteinDisplay, Colors.blue),
                  _buildUnitChip(unitDisplay, food.unit),
                ],
              ),
            ],
          ),

          onTap: () => _navigateToFoodDetails(food),
        ),
      ),
    );
  }

  Widget _buildMacroChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            _foods.isEmpty
                ? 'No foods in your library yet'
                : 'No foods match your search',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _foods.isEmpty
                ? 'Tap the + button to add your first food'
                : 'Try a different search term',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _navigateToAddFood() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen()),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  void _navigateToEditFood(FoodItem food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen(foodToEdit: food)),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  void _showDeleteConfirmation(FoodItem food) {
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
              Navigator.pop(context);
              _loadFoods();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToFoodDetails(FoodItem food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodDetailsScreen(food: food)),
    );
    if (result == true) {
      _loadFoods();
    }
  }
}
