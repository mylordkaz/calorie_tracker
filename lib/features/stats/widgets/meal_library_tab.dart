import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/add_entry_for_date_controller.dart';
import '../../../data/models/meal.dart';
import '../../../core/utils/localization_helper.dart';

class MealLibraryTab extends StatefulWidget {
  final AddEntryForDateController controller;
  final Function(String) onEntryAdded;

  const MealLibraryTab({
    Key? key,
    required this.controller,
    required this.onEntryAdded,
  }) : super(key: key);

  @override
  _MealLibraryTabState createState() => _MealLibraryTabState();
}

class _MealLibraryTabState extends State<MealLibraryTab> {
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
    widget.controller.onMealSearchChanged(_searchController.text);
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
          child: widget.controller.filteredMeals.isEmpty
              ? Center(child: Text(l10n.noMealsFound))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: widget.controller.filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = widget.controller.filteredMeals[index];
                    return _buildMealCard(meal);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMealCard(Meal meal) {
    final l10n = L10n.of(context);
    final macros = widget.controller.calculateMealMacros(meal);

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
    final l10n = L10n.of(context);
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

    final success = await widget.controller.addMealEntry(
      mealId: meal.id,
      multiplier: multiplier,
    );

    if (mounted && success) {
      Navigator.pop(context); // Close dialog
      widget.onEntryAdded(l10n.addedMealToLog(meal.name));
    }
  }
}
