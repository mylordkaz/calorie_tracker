import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../data/services/food_database_service.dart';
import '../../../../data/services/import_service.dart';
import '../../../../data/models/food_item.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/utils/localization_helper.dart';

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
  bool _isImporting = false;

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

    if (food.unit == 'serving') {
      if (food.servingDescription != null) {
        _servingDescriptionController.text = food.servingDescription!;
      }
      if (food.unitWeight != null) {
        _servingWeightController.text = food.unitWeight!.toString();
      }
    }

    if (food.unit == 'item' && food.unitWeight != null) {
      _unitWeightController.text = food.unitWeight!.toString();
    }

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
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? l10n.editFood : l10n.addNewFood),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: _isImporting ? null : _importFoods,
              icon: _isImporting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.download),
              tooltip: l10n.importFoods,
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
                  label: l10n.foodName,
                  hint: l10n.foodNameHint,
                  validator: (value) =>
                      value?.isEmpty == true ? l10n.nameRequired : null,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _descriptionController,
                  label: l10n.descriptionOptional,
                  hint: l10n.briefDescription,
                  maxLines: 2,
                ),
              ]),

              SizedBox(height: 16),

              // Photo Section
              _buildPhotoSection(),

              SizedBox(height: 16),

              // Unit Type & Nutrition
              _buildSection(_getNutritionSectionTitle(), [
                // Unit Selection
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: '100g',
                      label: Text(l10n.per100g, style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.straighten, size: 16),
                    ),
                    ButtonSegment<String>(
                      value: 'item',
                      label: Text(l10n.perItem, style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.egg, size: 16),
                    ),
                    ButtonSegment<String>(
                      value: 'serving',
                      label: Text(
                        l10n.perServing,
                        style: TextStyle(fontSize: 12),
                      ),
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
                    selectedBackgroundColor: Colors.blue,
                    selectedForegroundColor: Colors.white,
                  ),
                ),

                SizedBox(height: 8),
                Text(
                  _getUnitDescription(),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),

                if (_selectedUnit == 'serving') ...[
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _servingDescriptionController,
                          label: l10n.servingSize,
                          hint: l10n.servingSizeHint,
                          validator: (value) => value?.isEmpty == true
                              ? l10n.servingSizeRequired
                              : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          controller: _servingWeightController,
                          label: l10n.weightOptional,
                          suffix: 'g',
                          hint: l10n.weightInGrams,
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 16),

                // Main Nutrition Fields
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        controller: _caloriesController,
                        label: l10n.calories,
                        suffix: l10n.kcal,
                        isRequired: true,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildNumberField(
                        controller: _proteinController,
                        label: l10n.protein,
                        suffix: 'g',
                        isRequired: true,
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
                        label: l10n.carbs,
                        suffix: 'g',
                        isRequired: true,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildNumberField(
                        controller: _fatController,
                        label: l10n.fat,
                        suffix: 'g',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Additional Nutrients
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.additionalNutrients,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addCustomMacro,
                      icon: Icon(Icons.add, size: 16, color: Colors.blue),
                      label: Text(
                        l10n.add,
                        style: TextStyle(color: Colors.blue),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size(0, 28),
                      ),
                    ),
                  ],
                ),

                if (_customMacros.isNotEmpty) ...[
                  SizedBox(height: 8),
                  ...List.generate(_customMacros.length, (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _customMacros[index]['name'],
                              decoration: InputDecoration(
                                labelText: l10n.nutrientName,
                                hintText: l10n.nutrientNameHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                              style: TextStyle(fontSize: 12),
                              validator: (value) => value?.isEmpty == true
                                  ? l10n.nameRequired
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
                                labelText: l10n.amount,
                                suffixText: 'g',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                              style: TextStyle(fontSize: 12),
                              validator: (value) {
                                if (value?.isEmpty == true)
                                  return l10n.required;
                                if (double.tryParse(value!) == null)
                                  return l10n.invalid;
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _removeCustomMacro(index),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 16,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.all(4),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ]),

              SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? l10n.updateFood : l10n.saveFood,
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

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    String? hint,
    bool isRequired = false,
  }) {
    final l10n = L10n.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: isRequired
          ? (value) {
              if (value?.isEmpty == true) return l10n.fieldRequired(label);
              if (double.tryParse(value!) == null) return l10n.enterValidNumber;
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
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

    String foodName = _nameController.text.trim();
    if (foodName.isNotEmpty) {
      foodName = foodName[0].toUpperCase() + foodName.substring(1);
    }

    final food = FoodItem(
      id: isEditing
          ? widget.foodToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: foodName,
      description: _buildDescription(),
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

  String _getNutritionSectionTitle() {
    final l10n = L10n.of(context);
    switch (_selectedUnit) {
      case '100g':
        return "100g";
      case 'item':
        return l10n.items;
      case 'serving':
        return l10n.serving;
      default:
        return "100g";
    }
  }

  String _getUnitDescription() {
    final l10n = L10n.of(context);
    switch (_selectedUnit) {
      case '100g':
        return l10n.standardNutritionInfo;
      case 'item':
        return l10n.itemNutritionInfo;
      case 'serving':
        return l10n.servingNutritionInfo;
      default:
        return l10n.standardNutritionInfo;
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
      _customMacros[index]['name'].dispose();
      _customMacros[index]['value'].dispose();
      _customMacros.removeAt(index);
    });
  }

  Future<void> _importFoods() async {
    final l10n = L10n.of(context);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, size: 24),
            SizedBox(width: 8),
            Expanded(child: Text(l10n.importFoodLibrary)),
          ],
        ),
        content: Text(l10n.importFoodLibraryDescription),
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
      final result = await ImportService.importFoodLibrary();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? '${l10n.import} ${l10n.foods}: ${result.message}'
                : '${l10n.importFailed}: ${result.message}',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
          duration: Duration(seconds: result.success ? 3 : 4),
        ),
      );

      if (result.success) {
        // Go back to library to see imported foods
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
