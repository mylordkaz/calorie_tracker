import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../services/food_database_service.dart';
import '../../models/food_item.dart';
import '../../widgets/common/custom_card.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodItem? foodToEdit;

  const AddFoodScreen({this.foodToEdit});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String _selectedUnit = '100g';
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  final _servingDescriptionController = TextEditingController();
  final _servingWeightController = TextEditingController();

  final _unitWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  bool get isEditing => widget.foodToEdit != null;

  List<Map<String, dynamic>> _customMacros = [];

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _populateFields();
    }
  }

  @override
  void dispose() {
    for (var macro in _customMacros) {
      macro['name'].dispose();
      macro['value'].dispose();
    }
    _servingDescriptionController.dispose();
    _servingWeightController.dispose();
    _unitWeightController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final food = widget.foodToEdit!;
    _nameController.text = food.name;
    _descriptionController.text = food.description;

    _selectedUnit = food.unit;

    // Populate serving-specific fields if it's a serving
    if (food.unit == 'serving') {
      if (food.servingDescription != null) {
        _servingDescriptionController.text = food.servingDescription!;
      }
      if (food.unitWeight != null) {
        _servingWeightController.text = food.unitWeight!.toString();
      }
    }

    // For per_item, populate unit weight if available
    if (food.unit == 'per_item' && food.unitWeight != null) {
      _unitWeightController.text = food.unitWeight!.toString();
    }

    // Populate nutrition fields - these are now stored directly per unit
    _caloriesController.text = food.calories.toString();
    _proteinController.text = food.protein.toString();
    _carbsController.text = food.carbs.toString();
    _fatController.text = food.fat.toString();

    if (food.imagePath != null && File(food.imagePath!).existsSync()) {
      _imageFile = File(food.imagePath!);
    }

    if (food.customMacros != null) {
      _customMacros.clear();
      food.customMacros!.forEach((key, value) {
        _customMacros.add({
          'name': TextEditingController(text: key),
          'value': TextEditingController(text: value.toString()),
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Food' : 'Add New Food'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _saveFood,
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
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Basic Information', [
                _buildTextField(
                  controller: _nameController,
                  label: 'Food Name',
                  hint: 'e.g., Chicken Breast',
                  validator: (value) =>
                      value?.isEmpty == true ? 'Name is required' : null,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description (Optional)',
                  hint: 'e.g., Skinless, boneless',
                  maxLines: 2,
                ),
              ]),
              SizedBox(height: 24),

              // Replace the photo section with this expandable version
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

              _buildSection('Nutrition per ${_getUnitDisplayText()}', [
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: '100g',
                      label: Text('Per 100g'),
                      icon: Icon(Icons.straighten, size: 16),
                    ),
                    ButtonSegment<String>(
                      value: 'item',
                      label: Text('Per Item'),
                      icon: Icon(Icons.egg, size: 16),
                    ),
                    ButtonSegment<String>(
                      value: 'serving',
                      label: Text('per Serving'),
                      icon: Icon(Icons.local_dining, size: 16),
                    ),
                  ],
                  selected: {_selectedUnit},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _selectedUnit = selection.first;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
                    selectedBackgroundColor: Colors.green,
                    selectedForegroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _getUnitDescription(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),

                if (_selectedUnit == 'serving') ...[
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _servingDescriptionController,
                    label: 'Serving Size',
                    hint: 'e.g., 1 cup, 2 slices, 1 medium',
                    validator: (value) => value?.isEmpty == true
                        ? 'Serving size is required'
                        : null,
                  ),
                  SizedBox(height: 12),
                  _buildNumberField(
                    controller: _servingWeightController,
                    label: 'Serving Weight (Optional)',
                    suffix: 'g',
                    hint: 'Weight in grams',
                  ),
                ],

                SizedBox(height: 16),

                // Nutrition fields
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        controller: _caloriesController,
                        label: 'Calories',
                        suffix: 'kcal',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildNumberField(
                        controller: _proteinController,
                        label: 'Protein',
                        suffix: 'g',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        controller: _carbsController,
                        label: 'Carbs',
                        suffix: 'g',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildNumberField(
                        controller: _fatController,
                        label: 'Fat',
                        suffix: 'g',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Additional Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addCustomMacro,
                      icon: Icon(Icons.add, size: 16),
                      label: Text('Add'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),

                // Custom macros list
                if (_customMacros.isNotEmpty) ...[
                  SizedBox(height: 8),
                  ...List.generate(_customMacros.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _customMacros[index]['name'],
                              decoration: InputDecoration(
                                labelText: 'Nutrient name',
                                hintText: 'e.g., Fiber, Sodium',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              validator: (value) => value?.isEmpty == true
                                  ? 'Name required'
                                  : null,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _customMacros[index]['value'],
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                suffixText: 'g',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Required';
                                if (double.tryParse(value!) == null)
                                  return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _removeCustomMacro(index),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ]),
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
              fontSize: 18,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (value) {
        if (value?.isEmpty == true) return '$label is required';
        if (double.tryParse(value!) == null) return 'Enter a valid number';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  void _saveFood() async {
    if (!_formKey.currentState!.validate()) return;

    String? imagePath = await _saveImage();
    if (isEditing && imagePath == null) {
      imagePath = widget.foodToEdit!.imagePath;
    }

    double calories = double.parse(_caloriesController.text);
    double protein = double.parse(_proteinController.text);
    double carbs = double.parse(_carbsController.text);
    double fat = double.parse(_fatController.text);

    // Handle serving weight
    double? servingWeight;
    if (_selectedUnit == 'serving' &&
        _servingWeightController.text.isNotEmpty) {
      servingWeight = double.tryParse(_servingWeightController.text);
    }

    Map<String, double>? customMacros;
    if (_customMacros.isNotEmpty) {
      customMacros = {};
      for (var macro in _customMacros) {
        String name = macro['name'].text.trim();
        String valueStr = macro['value'].text.trim();
        if (name.isNotEmpty && valueStr.isNotEmpty) {
          customMacros[name] = double.parse(valueStr);
        }
      }
      if (customMacros.isEmpty) customMacros = null;
    }

    final food = FoodItem(
      id: isEditing
          ? widget.foodToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _buildDescription(), // Updated description
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      unit: _selectedUnit,
      unitWeight: servingWeight,
      customMacros: customMacros,
      createdAt: isEditing ? widget.foodToEdit!.createdAt : DateTime.now(),
      lastUsed: isEditing ? widget.foodToEdit!.lastUsed : DateTime.now(),
      useCount: isEditing ? widget.foodToEdit!.useCount : 0,
      imagePath: imagePath,
    );

    await FoodDatabaseService.addFood(food);
    Navigator.pop(context, true);
  }

  String _buildDescription() {
    String baseDescription = _descriptionController.text.trim();

    // If serving size, append serving info to description
    if (_selectedUnit == 'serving' &&
        _servingDescriptionController.text.isNotEmpty) {
      String servingInfo = _servingDescriptionController.text.trim();
      if (_servingWeightController.text.isNotEmpty) {
        servingInfo += ' (${_servingWeightController.text}g)';
      }

      if (baseDescription.isNotEmpty) {
        return '$baseDescription • $servingInfo';
      } else {
        return servingInfo;
      }
    }

    return baseDescription;
  }

  String _getUnitDisplayText() {
    switch (_selectedUnit) {
      case '100g':
        return '100g';
      case 'per_item':
        return 'Item';
      case 'serving':
        return 'Serving';
      default:
        return '100g';
    }
  }

  String _getUnitDescription() {
    switch (_selectedUnit) {
      case '100g':
        return 'Standard nutrition information per 100 grams';
      case 'per_item':
        return 'For foods like eggs, slices of bread, etc.';
      case 'serving':
        return 'US-style serving size (e.g., 1 cup, 2 slices)';
      default:
        return 'Standard nutrition information per 100 grams';
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

  void _addCustomMacro() {
    setState(() {
      _customMacros.add({
        'name': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void _removeCustomMacro(int index) {
    setState(() {
      // Dispose controllers to prevent memory leaks
      _customMacros[index]['name'].dispose();
      _customMacros[index]['value'].dispose();
      _customMacros.removeAt(index);
    });
  }
}
