import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/food_item.dart';
import '../../models/meal.dart';
import '../../services/food_database_service.dart';
import '../../services/daily_tracking_service.dart';
import '../../widgets/common/custom_card.dart';

class AddFoodEntryScreen extends StatefulWidget {
  @override
  _AddFoodEntryScreenState createState() => _AddFoodEntryScreenState();
}

class _AddFoodEntryScreenState extends State<AddFoodEntryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Add Food Entry'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Foods'),
              Tab(text: 'Meals'),
              Tab(text: 'Quick Entry'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_FoodLibraryTab(), _MealLibraryTab(), _QuickEntryTab()],
        ),
      ),
    );
  }
}

class _FoodLibraryTab extends StatefulWidget {
  @override
  _FoodLibraryTabState createState() => _FoodLibraryTabState();
}

class _FoodLibraryTabState extends State<_FoodLibraryTab> {
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(_onSearchChanged);
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search foods...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: _filteredFoods.isEmpty
              ? Center(child: Text('No foods found'))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildFoodCard(FoodItem food) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showQuantityDialog(food),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        food.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (food.description.isNotEmpty)
                        Text(
                          food.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  '${food.calories.toInt()} cal ${food.getDisplayUnit()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuantityDialog(FoodItem food) {
    final quantityController = TextEditingController();
    String selectedUnit;

    // Set initial values based on food type
    switch (food.unit) {
      case 'item':
        quantityController.text = '1';
        selectedUnit = 'items';
        break;
      case 'serving':
        quantityController.text = '1';
        selectedUnit = 'servings';
        break;
      default:
        quantityController.text = '100';
        selectedUnit = 'grams';
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Add ${food.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
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
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: _getUnitsForFood(food),
                onChanged: (value) =>
                    setDialogState(() => selectedUnit = value!),
                decoration: InputDecoration(
                  labelText: 'Unit',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  _addFoodEntry(food, quantityController.text, selectedUnit),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getUnitsForFood(FoodItem food) {
    switch (food.unit) {
      case 'item':
        return [DropdownMenuItem(value: 'items', child: Text('Items'))];
      case 'serving':
        return [
          DropdownMenuItem(value: 'servings', child: Text('Servings')),
          DropdownMenuItem(value: 'grams', child: Text('Grams')),
        ];
      default: // '100g'
        return [DropdownMenuItem(value: 'grams', child: Text('Grams'))];
    }
  }

  void _addFoodEntry(FoodItem food, String quantityText, String unit) async {
    final quantity = double.tryParse(quantityText);
    if (quantity == null || quantity <= 0) return;

    double grams;
    switch (unit) {
      case 'items':
        grams = quantity * food.getGramsPerUnit();
        break;
      case 'servings':
        grams = quantity * food.getGramsPerUnit();
        break;
      default:
        grams = quantity;
    }

    await DailyTrackingService.addFoodEntry(
      foodId: food.id,
      grams: grams,
      originalQuantity: quantity,
      originalUnit: unit,
    );

    if (mounted) {
      Navigator.pop(context); // Close dialog
      Navigator.pop(context, true); // Return to home with refresh signal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${food.name} to today\'s log')),
      );
    }
  }
}

class _MealLibraryTab extends StatefulWidget {
  @override
  _MealLibraryTabState createState() => _MealLibraryTabState();
}

class _MealLibraryTabState extends State<_MealLibraryTab> {
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
    _searchController.addListener(_onSearchChanged);
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search meals...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: _filteredMeals.isEmpty
              ? Center(child: Text('No meals found'))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildMealCard(Meal meal) {
    final macros = FoodDatabaseService.calculateMealMacros(meal);

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showMealQuantityDialog(meal),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${meal.getIngredientCount()} ingredients',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${macros['calories']!.toInt()} cal',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMealQuantityDialog(Meal meal) {
    final multiplierController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Add ${meal.name}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: multiplierController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: 'Servings',
                helperText: '1.0 = full meal, 0.5 = half meal',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _addMealEntry(meal, multiplierController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addMealEntry(Meal meal, String multiplierText) async {
    final multiplier = double.tryParse(multiplierText);
    if (multiplier == null || multiplier <= 0) return;

    await DailyTrackingService.addMealEntry(
      mealId: meal.id,
      multiplier: multiplier,
    );

    if (mounted) {
      Navigator.pop(context); // Close dialog
      Navigator.pop(context, true); // Return to home with refresh signal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${meal.name} to today\'s log')),
      );
    }
  }
}

class _QuickEntryTab extends StatefulWidget {
  @override
  _QuickEntryTabState createState() => _QuickEntryTabState();
}

class _QuickEntryTabState extends State<_QuickEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Calorie Entry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),

              // Food name
              TextFormField(
                controller: _nameController,
                validator: (value) =>
                    value?.isEmpty == true ? 'Name required' : null,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  hintText: 'e.g., Sandwich from café',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Calories (required)
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value?.isEmpty == true) return 'Calories required';
                  if (int.tryParse(value!) == null) return 'Enter valid number';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Calories *',
                  suffixText: 'kcal',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Optional nutrients section
              Text(
                'Nutrition Details (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12),

              // Protein, Carbs, Fat row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Protein',
                        hintText: '0',
                        suffixText: 'g',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Carbs',
                        hintText: '0',
                        suffixText: 'g',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Fat',
                        hintText: '0',
                        suffixText: 'g',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Helper text
              Text(
                'These can be edited later in the food library',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),

              // Add button
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _addQuickEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add Quick Entry',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addQuickEntry() async {
    if (!_formKey.currentState!.validate()) return;

    final calories = int.parse(_caloriesController.text);
    final name = _nameController.text.trim();

    final protein = _proteinController.text.isEmpty
        ? 0.0
        : double.tryParse(_proteinController.text) ?? 0.0;
    final carbs = _carbsController.text.isEmpty
        ? 0.0
        : double.tryParse(_carbsController.text) ?? 0.0;
    final fat = _fatController.text.isEmpty
        ? 0.0
        : double.tryParse(_fatController.text) ?? 0.0;

    // Ask user if they want to save to library
    final shouldSaveToLibrary = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Save to Library?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Text(
          'Do you want to save "$name" to your food library for future use?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: Text('No, just add today'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text('Yes, save to library'),
          ),
        ],
      ),
    );

    if (shouldSaveToLibrary == null) return; // User cancelled

    if (shouldSaveToLibrary) {
      // Save to food library and add regular entry
      final quickFood = FoodItem(
        id: 'quick_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: 'Quick entry',
        calories: calories.toDouble(),
        protein: protein,
        carbs: carbs,
        fat: fat,
        createdAt: DateTime.now(),
        lastUsed: DateTime.now(),
      );

      await FoodDatabaseService.addFood(quickFood);
      await DailyTrackingService.addFoodEntry(foodId: quickFood.id, grams: 100);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name saved to library and added to today\'s log'),
            action: SnackBarAction(label: 'Edit in Library', onPressed: () {}),
          ),
        );
      }
    } else {
      // Add as quick entry only
      await DailyTrackingService.addQuickFoodEntry(
        name: name,
        calories: calories.toDouble(),
        protein: protein,
        carbs: carbs,
        fat: fat,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $name ($calories cal) to today\'s log'),
          ),
        );
      }
    }
  }
}
