import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/food_database_service.dart';
import '../../models/meal.dart';
import '../../widgets/common/custom_card.dart';
import 'add_meal_screen.dart';
import 'meal_details_screen.dart';

class MealLibraryTab extends StatefulWidget {
  @override
  _MealLibraryTabState createState() => _MealLibraryTabState();
}

class _MealLibraryTabState extends State<MealLibraryTab> {
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadMeals() {
    setState(() {
      _meals = FoodDatabaseService.getAllMeals();
      _filteredMeals = _meals;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _filteredMeals = FoodDatabaseService.searchMeals(_searchController.text);
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
                  hintText: 'Search meals...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Meals List
          Expanded(
            child: _filteredMeals.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _filteredMeals[index];
                      return _buildMealCard(meal);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddMeal(),
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    final macros = FoodDatabaseService.calculateMealMacros(meal);
    final totalWeight = meal.getTotalWeight();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: meal.imagePath != null && File(meal.imagePath!).existsSync()
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(meal.imagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          title: Text(
            meal.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (meal.description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    meal.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              SizedBox(height: 8),
              Text(
                '${meal.getIngredientCount()} ingredients • ${totalWeight.toInt()}g total',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildMacroChip(
                    '${macros['calories']!.toInt()} cal',
                    Colors.orange,
                  ),
                  _buildMacroChip(
                    '${macros['protein']!.toStringAsFixed(1)}g protein',
                    Colors.blue,
                  ),
                  if (meal.category != null) _buildCategoryChip(meal.category!),
                  if (meal.isFavorite) _buildFavoriteChip(),
                ],
              ),
            ],
          ),
          onTap: () => _navigateToMealDetails(meal),
        ),
      ),
    );
  }

  Widget _buildMacroChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.purple,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFavoriteChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Icon(Icons.favorite, size: 12, color: Colors.red),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_dining_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            _meals.isEmpty
                ? 'No meals in your library yet'
                : 'No meals match your search',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _meals.isEmpty
                ? 'Tap the + button to create your first meal'
                : 'Try a different search term',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _navigateToAddMeal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMealScreen()),
    );
    if (result == true) {
      _loadMeals();
    }
  }

  void _navigateToMealDetails(Meal meal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealDetailsScreen(meal: meal)),
    );
    if (result == true) {
      _loadMeals();
    }
  }
}
