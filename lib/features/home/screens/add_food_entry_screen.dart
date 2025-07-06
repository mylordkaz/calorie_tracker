import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/localization_helper.dart';
import '../../../data/models/food_item.dart';
import '../../../data/models/meal.dart';
import '../../../data/services/food_database_service.dart';
import '../../../data/services/daily_tracking_service.dart';
import '../../../shared/widgets/custom_dropdown.dart';

class AddFoodEntryScreen extends StatefulWidget {
  @override
  _AddFoodEntryScreenState createState() => _AddFoodEntryScreenState();
}

class _AddFoodEntryScreenState extends State<AddFoodEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(l10n.addFoodEntry),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: l10n.foods),
              Tab(text: l10n.meals),
              Tab(text: l10n.quickEntry),
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
    final l10n = L10n.of(context);

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
                hintText: l10n.searchFoods,
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
              ? Center(child: Text(l10n.noFoodsFound))
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
    final l10n = L10n.of(context);
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
          onTap: () => _showFoodEntryDialog(food),
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
                      Text(
                        food.description,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${food.calories.toInt()} ${l10n.cal} ${food.getDisplayUnit()}',
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

  void _showFoodEntryDialog(FoodItem food) {
    final l10n = L10n.of(context);
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
            l10n.addFoodTitle(food.name),
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
                  labelText: l10n.quantity,
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
              CustomDropdown<String>(
                value: selectedUnit,
                hintText: l10n.unit,
                items: _getCustomUnitsForFood(food, context),
                onChanged: (value) =>
                    setDialogState(() => selectedUnit = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              child: Text(l10n.cancel),
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
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownItem<String>> _getCustomUnitsForFood(
    FoodItem food,
    BuildContext context,
  ) {
    final l10n = L10n.of(context);

    switch (food.unit) {
      case 'item':
        return [DropdownItem(value: 'items', text: l10n.items)];
      case 'serving':
        return [
          DropdownItem(value: 'servings', text: l10n.servings),
          DropdownItem(value: 'grams', text: l10n.grams),
        ];
      default: // '100g'
        return [DropdownItem(value: 'grams', text: l10n.grams)];
    }
  }

  void _addFoodEntry(FoodItem food, String quantityText, String unit) async {
    final l10n = L10n.of(context);
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.addedFoodToLog(food.name))));
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
    final l10n = L10n.of(context);

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
                hintText: l10n.searchMeals,
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
              ? Center(child: Text(l10n.noMealsFound))
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
    final l10n = L10n.of(context);
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
                        l10n.ingredientsCount(meal.getIngredientCount()),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${macros['calories']!.toInt()} ${l10n.cal}',
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
    final l10n = L10n.of(context);
    final multiplierController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          l10n.addMealTitle(meal.name),
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
                labelText: l10n.servings,
                helperText: l10n.servingsHelperText,
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
            child: Text(l10n.cancel),
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
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _addMealEntry(Meal meal, String multiplierText) async {
    final l10n = L10n.of(context);
    final multiplier = double.tryParse(multiplierText);
    if (multiplier == null || multiplier <= 0) return;

    await DailyTrackingService.addMealEntry(
      mealId: meal.id,
      multiplier: multiplier,
    );

    if (mounted) {
      Navigator.pop(context); // Close dialog
      Navigator.pop(context, true); // Return to home with refresh signal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.addedMealToLog(meal.name))));
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
    final l10n = L10n.of(context);

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
              // Food name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.foodName,
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
                validator: (value) => value?.isEmpty == true
                    ? l10n.fieldRequired(l10n.foodName)
                    : null,
              ),
              SizedBox(height: 16),

              // Calories field
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.calories,
                  hintText: l10n.hintZero,
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
                validator: (value) => value?.isEmpty == true
                    ? l10n.fieldRequired(l10n.calories)
                    : null,
              ),
              SizedBox(height: 16),

              // Optional nutrients section
              Text(
                l10n.nutritionDetailsOptional,
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
                        labelText: l10n.protein,
                        hintText: l10n.hintZero,
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
                        labelText: l10n.carbs,
                        hintText: l10n.hintZero,
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
                        labelText: l10n.fat,
                        hintText: l10n.hintZero,
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
                l10n.nutritionEditLater,
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
                      l10n.addQuickEntry,
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
    final l10n = L10n.of(context);

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
          l10n.saveToLibrary,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Text(
          l10n.saveToLibraryPrompt(name),
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: Text(l10n.noJustAddToday),
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
            child: Text(l10n.yesSaveToLibrary),
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
        description: l10n.quickEntryLower,
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
            content: Text(l10n.savedToLibraryAndAdded(name)),
            action: SnackBarAction(label: l10n.editInLibrary, onPressed: () {}),
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
          SnackBar(content: Text(l10n.addedWithCalories(name, calories))),
        );
      }
    }
  }
}
