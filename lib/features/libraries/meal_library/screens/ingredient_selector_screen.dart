import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/food_item.dart';
import '../../../../data/models/meal.dart';
import '../../../../data/services/food_database_service.dart';
import '../../../../shared/widgets/custom_card.dart';

class IngredientSelectorScreen extends StatefulWidget {
  final FoodItem? selectedFood;
  final double? initialQuantity;
  final String? initialUnit;

  const IngredientSelectorScreen({
    this.selectedFood,
    this.initialQuantity,
    this.initialUnit,
  });

  @override
  _IngredientSelectorScreenState createState() =>
      _IngredientSelectorScreenState();
}

class _IngredientSelectorScreenState extends State<IngredientSelectorScreen> {
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  FoodItem? _selectedFood;
  String _selectedUnit = 'grams';

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(_onSearchChanged);

    if (widget.selectedFood != null) {
      _selectedFood = widget.selectedFood;
      _quantityController.text = widget.initialQuantity?.toString() ?? '';
      _selectedUnit = widget.initialUnit ?? 'grams';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Add Ingredient'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _canSave() ? _saveIngredient : null,
            child: Text(
              'Add',
              style: TextStyle(
                color: _canSave() ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
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

          // Selected Food & Quantity
          if (_selectedFood != null) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: CustomCard(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Selected: ${_selectedFood!.name}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Quantity Input Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Unit Selection
                        Expanded(
                          child: Container(
                            height: 48,
                            child: DropdownButtonFormField<String>(
                              value: _selectedUnit,
                              items: _getAvailableUnits(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedUnit = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Unit',
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Nutrition Preview
                    if (_quantityController.text.isNotEmpty) ...[
                      SizedBox(height: 16),
                      _buildNutritionPreview(),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
          ],

          // Foods List
          Expanded(
            child: _filteredFoods.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      final isSelected = _selectedFood?.id == food.id;
                      return _buildFoodCard(food, isSelected);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      height: 56,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _selectFood(food),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                if (isSelected)
                  Icon(Icons.check_circle, color: Colors.blue, size: 20)
                else
                  Icon(
                    Icons.circle_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                SizedBox(width: 12),
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
                          color: isSelected ? Colors.blue : Colors.black,
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

  Widget _buildNutritionPreview() {
    if (_selectedFood == null || _quantityController.text.isEmpty) {
      return Container();
    }

    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null) return Container();

    final ingredient = MealIngredient.fromQuantity(
      foodId: _selectedFood!.id,
      food: _selectedFood!,
      quantity: quantity,
      inputUnit: _selectedUnit,
    );

    final macros = ingredient.calculateMacros(_selectedFood!);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue),
              SizedBox(width: 6),
              Text(
                'Nutrition for ${ingredient.getDisplayQuantity(_selectedFood!)}:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildPreviewChip(
                '${macros['calories']!.toInt()} cal',
                Colors.orange,
              ),
              _buildPreviewChip(
                '${macros['protein']!.toStringAsFixed(1)}g protein',
                Colors.blue,
              ),
              _buildPreviewChip(
                '${macros['carbs']!.toStringAsFixed(1)}g carbs',
                Colors.green,
              ),
              _buildPreviewChip(
                '${macros['fat']!.toStringAsFixed(1)}g fat',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No foods found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getAvailableUnits() {
    if (_selectedFood == null) {
      return [
        DropdownMenuItem(
          value: 'grams',
          child: Text('Grams', style: TextStyle(fontSize: 14)),
        ),
      ];
    }

    switch (_selectedFood!.unit) {
      case '100g':
        return [
          DropdownMenuItem(
            value: 'grams',
            child: Text('Grams', style: TextStyle(fontSize: 14)),
          ),
        ];
      case 'item':
        return [
          DropdownMenuItem(
            value: 'items',
            child: Text('Items', style: TextStyle(fontSize: 14)),
          ),
        ];
      case 'serving':
        return [
          DropdownMenuItem(
            value: 'servings',
            child: Text('Servings', style: TextStyle(fontSize: 14)),
          ),
          DropdownMenuItem(
            value: 'grams',
            child: Text('Grams', style: TextStyle(fontSize: 14)),
          ),
        ];
      default:
        return [
          DropdownMenuItem(
            value: 'grams',
            child: Text('Grams', style: TextStyle(fontSize: 14)),
          ),
        ];
    }
  }

  void _selectFood(FoodItem food) {
    setState(() {
      _selectedFood = food;
      switch (food.unit) {
        case 'item':
          _selectedUnit = 'items';
          break;
        case 'serving':
          _selectedUnit = 'servings';
          break;
        case '100g':
        default:
          _selectedUnit = 'grams';
          break;
      }

      if (_quantityController.text.isEmpty) {
        switch (food.unit) {
          case 'item':
          case 'serving':
            _quantityController.text = '1';
            break;
          case '100g':
          default:
            _quantityController.text = '100';
            break;
        }
      }
    });
  }

  bool _canSave() {
    return _selectedFood != null &&
        _quantityController.text.isNotEmpty &&
        double.tryParse(_quantityController.text) != null &&
        double.parse(_quantityController.text) > 0;
  }

  void _saveIngredient() {
    if (!_canSave()) return;

    final quantity = double.parse(_quantityController.text);
    final ingredient = MealIngredient.fromQuantity(
      foodId: _selectedFood!.id,
      food: _selectedFood!,
      quantity: quantity,
      inputUnit: _selectedUnit,
    );

    Navigator.pop(context, ingredient);
  }
}
