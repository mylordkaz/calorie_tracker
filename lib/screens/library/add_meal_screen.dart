import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../models/meal.dart';
import '../../services/food_database_service.dart';
import '../../widgets/common/custom_card.dart';
import 'ingredient_selector_screen.dart';

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
    final macros = _calculateTotalMacros();
    final totalWeight = _calculateTotalWeight();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Meal' : 'Create New Meal'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _saveMeal,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              CustomCard(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Name field
                    Container(
                      height: 44,
                      child: TextFormField(
                        controller: _nameController,
                        validator: (value) =>
                            value?.isEmpty == true ? 'Name is required' : null,
                        decoration: InputDecoration(
                          labelText: 'Meal Name',
                          hintText: 'e.g., Chicken & Rice Bowl',
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
                      ),
                    ),

                    SizedBox(height: 8),

                    // Description and Category
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 44,
                            child: TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: 'High protein meal',
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
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 44,
                            child: TextFormField(
                              controller: _categoryController,
                              decoration: InputDecoration(
                                labelText: 'Category',
                                hintText: 'Lunch',
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Photo section
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    'Add a picture ?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(
                    _imageFile != null ? Icons.photo : Icons.add_a_photo,
                    color: _imageFile != null ? Colors.green : Colors.grey[600],
                  ),
                  trailing: _imageFile != null
                      ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                      : null,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _imageFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 32,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Tap to add photo',
                                          style: TextStyle(
                                            color: Colors.grey[600],
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
                                  icon: Icon(Icons.edit, size: 16),
                                  label: Text('Change'),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      setState(() => _imageFile = null),
                                  icon: Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Ingredients Section
              CustomCard(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${_ingredients.length} ingredients',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _addIngredient,
                          icon: Icon(Icons.add, size: 14),
                          label: Text('Add', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            minimumSize: Size(0, 32),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Ingredients List
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

                // Nutrition Summary - More compact
                CustomCard(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nutrition Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Total: ${totalWeight.toInt()}g',
                            style: TextStyle(
                              fontSize: 12,
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
                              'Calories',
                              macros['calories']!,
                              'kcal',
                              Colors.orange,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildMacroCard(
                              'Protein',
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
                              'Carbs',
                              macros['carbs']!,
                              'g',
                              Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildMacroCard(
                              'Fat',
                              macros['fat']!,
                              'g',
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyIngredientsState() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.restaurant_menu, size: 36, color: Colors.grey[400]),
          SizedBox(height: 12),
          Text(
            'No ingredients added yet',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tap "Add" to start building your meal',
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
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
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      ingredient.getDisplayQuantity(food),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
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
                    constraints: BoxConstraints(minWidth: 28, minHeight: 28),
                    padding: EdgeInsets.all(4),
                  ),
                  IconButton(
                    onPressed: () => _removeIngredient(index),
                    icon: Icon(Icons.delete, size: 16, color: Colors.red),
                    constraints: BoxConstraints(minWidth: 28, minHeight: 28),
                    padding: EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [
              _buildSmallMacroChip(
                '${macros['calories']!.toInt()} cal',
                Colors.orange,
              ),
              _buildSmallMacroChip(
                '${macros['protein']!.toStringAsFixed(1)}g protein',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, double value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(unit, style: TextStyle(fontSize: 9, color: color)),
        ],
      ),
    );
  }

  Widget _buildSmallMacroChip(String text, Color color) {
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
          fontSize: 10,
          fontWeight: FontWeight.w500,
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
    final ingredient = _ingredients[index];
    final food = FoodDatabaseService.getFood(ingredient.foodId);
    if (food == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientSelectorScreen(
          selectedFood: food,
          initialQuantity: ingredient.originalQuantity ?? ingredient.grams,
          initialUnit: ingredient.originalUnit ?? 'grams',
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
    if (!_formKey.currentState!.validate()) return;

    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    String? imagePath = await _saveImage();
    if (isEditing && imagePath == null) {
      imagePath = widget.mealToEdit!.imagePath;
    }

    final meal = Meal(
      id: isEditing
          ? widget.mealToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
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
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.green),
              title: Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
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
}
