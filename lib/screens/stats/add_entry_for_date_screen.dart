import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/food_item.dart';
import '../../models/meal.dart';
import '../../services/food_database_service.dart';
import '../../services/daily_tracking_service.dart';
import '../../widgets/common/custom_card.dart';

class AddEntryForDateScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddEntryForDateScreen({required this.selectedDate});

  @override
  _AddEntryForDateScreenState createState() => _AddEntryForDateScreenState();
}

class _AddEntryForDateScreenState extends State<AddEntryForDateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Food tab
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  final TextEditingController _foodSearchController = TextEditingController();

  // Meal tab
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  final TextEditingController _mealSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    _foodSearchController.addListener(_onFoodSearchChanged);
    _mealSearchController.addListener(_onMealSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _foodSearchController.dispose();
    _mealSearchController.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _foods = FoodDatabaseService.getAllFoods();
      _filteredFoods = _foods;
      _meals = FoodDatabaseService.getAllMeals();
      _filteredMeals = _meals;
    });
  }

  void _onFoodSearchChanged() {
    setState(() {
      _filteredFoods = FoodDatabaseService.searchFoods(
        _foodSearchController.text,
      );
    });
  }

  void _onMealSearchChanged() {
    setState(() {
      _filteredMeals = FoodDatabaseService.searchMeals(
        _mealSearchController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Add Entry - ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          tabs: [
            Tab(text: 'Foods'),
            Tab(text: 'Meals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFoodTab(), _buildMealTab()],
      ),
    );
  }

  Widget _buildFoodTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: EdgeInsets.all(16),
          child: CustomCard(
            child: TextField(
              controller: _foodSearchController,
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
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredFoods.length,
            itemBuilder: (context, index) {
              final food = _filteredFoods[index];
              return _buildFoodCard(food);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMealTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: EdgeInsets.all(16),
          child: CustomCard(
            child: TextField(
              controller: _mealSearchController,
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
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredMeals.length,
            itemBuilder: (context, index) {
              final meal = _filteredMeals[index];
              return _buildMealCard(meal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: CustomCard(
        padding: EdgeInsets.all(12),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            food.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Text(
            '${food.calories.toInt()} cal • ${food.protein.toStringAsFixed(1)}g protein ${food.getDisplayUnit()}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          onTap: () => _showFoodQuantityDialog(food),
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    final macros = FoodDatabaseService.calculateMealMacros(meal);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: CustomCard(
        padding: EdgeInsets.all(12),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            meal.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Text(
            '${macros['calories']!.toInt()} cal • ${meal.getIngredientCount()} ingredients',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          onTap: () => _showMealQuantityDialog(meal),
        ),
      ),
    );
  }

  void _showFoodQuantityDialog(FoodItem food) {
    final quantityController = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${food.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: 'Quantity',
                suffixText: food.unit == '100g'
                    ? 'g'
                    : food.unit == 'item'
                    ? 'items'
                    : 'servings',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantity = double.tryParse(quantityController.text);
              if (quantity != null && quantity > 0) {
                double grams;
                switch (food.unit) {
                  case '100g':
                    grams = quantity;
                    break;
                  case 'item':
                  case 'serving':
                    grams = quantity * food.getGramsPerUnit();
                    break;
                  default:
                    grams = quantity;
                }

                await DailyTrackingService.addFoodEntryForDate(
                  foodId: food.id,
                  grams: grams,
                  date: widget.selectedDate,
                  originalQuantity: quantity,
                  originalUnit: food.unit,
                );

                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(
                    context,
                    true,
                  ); // Return to stats with refresh signal
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${food.name} added!')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMealQuantityDialog(Meal meal) {
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${meal.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: 'Servings',
                suffixText: 'portions',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantity = double.tryParse(quantityController.text);
              if (quantity != null && quantity > 0) {
                await DailyTrackingService.addMealEntryForDate(
                  mealId: meal.id,
                  multiplier: quantity,
                  date: widget.selectedDate,
                );

                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(
                    context,
                    true,
                  ); // Return to stats with refresh signal
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${meal.name} added!')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
