import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/food_item.dart';
import '../../models/meal.dart';
import '../../services/food_database_service.dart';
import '../../widgets/common/custom_card.dart';

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
                color: _canSave() ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search foods...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),

          // Selected Food & Quantity
          if (_selectedFood != null) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: CustomCard(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected: ${_selectedFood!.name}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Quantity Input
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 44,
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              style: TextStyle(fontSize: 14),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Unit buttons
                        Container(
                          height: 44,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _getAvailableUnits().map((unit) {
                              final isSelected = _selectedUnit == unit['value'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedUnit = unit['value']!;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  margin: EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Text(
                                    unit['label']!,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                    // Nutrition Preview
                    if (_quantityController.text.isNotEmpty) ...[
                      SizedBox(height: 12),
                      _buildNutritionPreview(),
                    ],
                  ],
                ),
              ),
            ),
          ],

          // Foods List Title
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              _selectedFood != null ? 'List of foods:' : 'Choose a food:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
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
      child: CustomCard(
        padding: EdgeInsets.all(10),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          title: Text(
            food.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isSelected ? Colors.green : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (food.description.isNotEmpty)
                Text(
                  food.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              SizedBox(height: 2),
              Text(
                '${food.calories.toInt()} cal • ${food.protein.toStringAsFixed(1)}g protein ${food.getDisplayUnit()}',
                style: TextStyle(color: Colors.grey[500], fontSize: 10),
              ),
            ],
          ),
          leading: isSelected
              ? Icon(Icons.check_circle, color: Colors.green, size: 20)
              : null,
          onTap: () {
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
          },
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition for ${ingredient.getDisplayQuantity(_selectedFood!)}:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 3,
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
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
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

  List<Map<String, String>> _getAvailableUnits() {
    if (_selectedFood == null) {
      return [
        {'value': 'grams', 'label': 'g'},
      ];
    }

    switch (_selectedFood!.unit) {
      case '100g':
        return [
          {'value': 'grams', 'label': 'g'},
        ];
      case 'item':
        return [
          {'value': 'items', 'label': 'items'},
        ];
      case 'serving':
        return [
          {'value': 'servings', 'label': 'servings'},
          {'value': 'grams', 'label': 'g'},
        ];
      default:
        return [
          {'value': 'grams', 'label': 'g'},
        ];
    }
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
