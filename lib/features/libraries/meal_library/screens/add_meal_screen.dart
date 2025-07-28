import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../data/models/meal.dart';
import '../../../../data/services/food_database_service.dart';
import '../../../../data/services/import_service.dart';
import '../../../../shared/widgets/custom_card.dart';
import 'ingredient_selector_screen.dart';
import '../../../../core/utils/localization_helper.dart';

class AddMealScreen extends StatefulWidget {
  final Meal? mealToEdit;

  const AddMealScreen({this.mealToEdit});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  List<MealIngredient> _ingredients = [];
  bool get isEditing => widget.mealToEdit != null;
  bool _isImporting = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _populateFields();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final meal = widget.mealToEdit!;
    _nameController.text = meal.name;
    _descriptionController.text = meal.description;
    _categoryController.text = meal.category ?? '';
    _ingredients = List.from(meal.ingredients);

    if (meal.imagePath != null && File(meal.imagePath!).existsSync()) {
      _imageFile = File(meal.imagePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final macros = _calculateTotalMacros();
    final totalWeight = _calculateTotalWeight();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? l10n.editMeal : l10n.createNewMeal),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: _isImporting ? null : _importMeals,
              icon: _isImporting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.download),
              tooltip: l10n.importMeals,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildSection(l10n.basicInformation, [
                _buildTextField(
                  controller: _nameController,
                  label: l10n.mealName,
                  hint: l10n.mealNameHint,
                  validator: (value) =>
                      value?.isEmpty == true ? l10n.nameRequired : null,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _descriptionController,
                        label: l10n.descriptionOptional,
                        hint: l10n.mealDescHint,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _categoryController,
                        label: l10n.category,
                        hint: l10n.categoryHint,
                      ),
                    ),
                  ],
                ),
              ]),

              SizedBox(height: 16),

              // Photo Section
              _buildPhotoSection(),

              SizedBox(height: 16),

              // Ingredients Section
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.ingredients(_ingredients.length),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addIngredient,
                          icon: Icon(Icons.add, size: 16),
                          label: Text(l10n.add, style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size(0, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    if (_ingredients.isEmpty)
                      _buildEmptyIngredientsState()
                    else
                      ..._ingredients.asMap().entries.map((entry) {
                        int index = entry.key;
                        MealIngredient ingredient = entry.value;
                        return _buildIngredientCard(ingredient, index);
                      }),
                  ],
                ),
              ),

              if (_ingredients.isNotEmpty) ...[
                SizedBox(height: 16),

                // Nutrition Summary
                _buildSection(l10n.nutritionSummary, [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Weight: ${totalWeight.toInt()}g',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroCard(
                          l10n.calories,
                          macros['calories']!,
                          l10n.kcal,
                          Colors.orange,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildMacroCard(
                          l10n.protein,
                          macros['protein']!,
                          'g',
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroCard(
                          l10n.carbs,
                          macros['carbs']!,
                          'g',
                          Colors.green,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildMacroCard(
                          l10n.fat,
                          macros['fat']!,
                          'g',
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ]),
              ],

              SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? l10n.updateMeal : l10n.saveMeal,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
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
              fontSize: 16,
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

  Widget _buildPhotoSection() {
    final l10n = L10n.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.photoOptional,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _imageFile != null
                    ? Colors.transparent
                    : Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _imageFile != null
                      ? Colors.grey[300]!
                      : Colors.blue.withOpacity(0.3),
                ),
              ),
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 32, color: Colors.blue),
                        SizedBox(height: 8),
                        Text(
                          l10n.tapToAdd,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_imageFile != null) ...[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.edit, size: 16, color: Colors.blue),
                  label: Text(
                    l10n.change,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _imageFile = null),
                  icon: Icon(Icons.delete, size: 16, color: Colors.red),
                  label: Text(l10n.remove, style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: TextStyle(fontSize: 14),
    );
  }

  Widget _buildEmptyIngredientsState() {
    final l10n = L10n.of(context);
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.restaurant_menu, size: 36, color: Colors.grey[400]),
          SizedBox(height: 12),
          Text(
            l10n.noIngredientsYet,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            l10n.tapAddIngredientHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCard(MealIngredient ingredient, int index) {
    final food = FoodDatabaseService.getFood(ingredient.foodId);
    if (food == null) {
      return Container();
    }

    final macros = ingredient.calculateMacros(food);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
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
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      ingredient.getDisplayQuantity(food),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editIngredient(index),
                    icon: Icon(Icons.edit, size: 16, color: Colors.blue),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                  IconButton(
                    onPressed: () => _removeIngredient(index),
                    icon: Icon(Icons.delete, size: 16, color: Colors.red),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 6,
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

  Widget _buildMacroCard(String label, double value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(unit, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildSmallMacroChip(String text, Color color) {
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

  Map<String, double> _calculateTotalMacros() {
    Map<String, double> totalMacros = {
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };

    for (var ingredient in _ingredients) {
      var food = FoodDatabaseService.getFood(ingredient.foodId);
      if (food != null) {
        var macros = ingredient.calculateMacros(food);
        totalMacros['calories'] =
            totalMacros['calories']! + macros['calories']!;
        totalMacros['protein'] = totalMacros['protein']! + macros['protein']!;
        totalMacros['carbs'] = totalMacros['carbs']! + macros['carbs']!;
        totalMacros['fat'] = totalMacros['fat']! + macros['fat']!;
      }
    }

    return totalMacros;
  }

  double _calculateTotalWeight() {
    return _ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.grams);
  }

  void _addIngredient() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IngredientSelectorScreen()),
    );

    if (result != null && result is MealIngredient) {
      setState(() {
        _ingredients.add(result);
      });
    }
  }

  void _editIngredient(int index) async {
    final l10n = L10n.of(context);
    final ingredient = _ingredients[index];
    final food = FoodDatabaseService.getFood(ingredient.foodId);
    if (food == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientSelectorScreen(
          selectedFood: food,
          initialQuantity: ingredient.originalQuantity ?? ingredient.grams,
          initialUnit: ingredient.originalUnit ?? l10n.grams,
        ),
      ),
    );

    if (result != null && result is MealIngredient) {
      setState(() {
        _ingredients[index] = result;
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _saveMeal() async {
    final l10n = L10n.of(context);

    if (!_formKey.currentState!.validate()) return;

    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseAddOneIngredient)));
      return;
    }

    String? imagePath = await _saveImage();
    if (isEditing && imagePath == null) {
      imagePath = widget.mealToEdit!.imagePath;
    }

    // Capitalize first letter of meal name
    String mealName = _nameController.text.trim();
    if (mealName.isNotEmpty) {
      mealName = mealName[0].toUpperCase() + mealName.substring(1);
    }

    final meal = Meal(
      id: isEditing
          ? widget.mealToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: mealName,
      description: _descriptionController.text.trim(),
      ingredients: _ingredients,
      createdAt: isEditing ? widget.mealToEdit!.createdAt : DateTime.now(),
      lastUsed: isEditing ? widget.mealToEdit!.lastUsed : DateTime.now(),
      useCount: isEditing ? widget.mealToEdit!.useCount : 0,
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      isFavorite: isEditing ? widget.mealToEdit!.isFavorite : false,
      imagePath: imagePath,
    );

    await FoodDatabaseService.addMeal(meal);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickImage() async {
    final source = await _showImageSourceDialog();
    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    final l10n = L10n.of(context);

    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectImageSource),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text(l10n.camera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue),
              title: Text(l10n.gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<String?> _saveImage() async {
    if (_imageFile == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await _imageFile!.copy('${directory.path}/$imageName');
    return savedImage.path;
  }

  Future<void> _importMeals() async {
    final l10n = L10n.of(context);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, size: 24),
            SizedBox(width: 8),
            Expanded(child: Text(l10n.importMealLibrary)),
          ],
        ),
        content: Text(l10n.importMealLibraryDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(Icons.download, size: 18),
            label: Text(l10n.import),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    setState(() {
      _isImporting = true;
    });

    try {
      final result = await ImportService.importMealLibrary();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? '${l10n.import} ${l10n.meals}: ${result.message}'
                : '${l10n.importFailed}: ${result.message}',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
          duration: Duration(seconds: result.success ? 3 : 4),
        ),
      );

      if (result.success) {
        // Go back to library to see imported meals
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.importFailed}: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }
}
