import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/add_entry_for_date_controller.dart';
import '../../../data/models/food_item.dart';
import '../../../shared/widgets/custom_dropdown.dart';

class FoodLibraryTab extends StatefulWidget {
  final AddEntryForDateController controller;
  final Function(String) onEntryAdded;

  const FoodLibraryTab({
    Key? key,
    required this.controller,
    required this.onEntryAdded,
  }) : super(key: key);

  @override
  _FoodLibraryTabState createState() => _FoodLibraryTabState();
}

class _FoodLibraryTabState extends State<FoodLibraryTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.controller.onFoodSearchChanged(_searchController.text);
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
          child: widget.controller.filteredFoods.isEmpty
              ? Center(child: Text('No foods found'))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: widget.controller.filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = widget.controller.filteredFoods[index];
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
              CustomDropdown<String>(
                value: selectedUnit,
                hintText: 'Unit',
                items: _getCustomUnitsForFood(food),
                onChanged: (value) =>
                    setDialogState(() => selectedUnit = value!),
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

  List<DropdownItem<String>> _getCustomUnitsForFood(FoodItem food) {
    switch (food.unit) {
      case 'item':
        return [DropdownItem(value: 'items', text: 'Items')];
      case 'serving':
        return [
          DropdownItem(value: 'servings', text: 'Servings'),
          DropdownItem(value: 'grams', text: 'Grams'),
        ];
      default: // '100g'
        return [DropdownItem(value: 'grams', text: 'Grams')];
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

    final success = await widget.controller.addFoodEntry(
      foodId: food.id,
      grams: grams,
      originalQuantity: quantity,
      originalUnit: unit,
    );

    if (mounted && success) {
      Navigator.pop(context); // Close dialog
      widget.onEntryAdded(
        'Added ${food.name} to ${widget.controller.selectedDate.day}/${widget.controller.selectedDate.month}',
      );
    }
  }
}
