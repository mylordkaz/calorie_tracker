import 'package:flutter/material.dart';
import '../../../../data/repositories/food_repository.dart';
import '../../../../data/models/food_item.dart';

class FoodLibraryController extends ChangeNotifier {
  final FoodRepository _foodRepository;

  FoodLibraryController({required FoodRepository foodRepository})
    : _foodRepository = foodRepository;

  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  String _searchQuery = '';
  bool _isLoading = true;

  // Getters
  List<FoodItem> get foods => _foods;
  List<FoodItem> get filteredFoods => _filteredFoods;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isEmpty => _foods.isEmpty;
  bool get hasSearchResults =>
      _filteredFoods.isNotEmpty || _searchQuery.isEmpty;

  // Initialize and load data
  Future<void> loadFoods() async {
    try {
      _isLoading = true;
      notifyListeners();

      _foods = _foodRepository.getAllFoods();
      _filteredFoods = _foods;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading foods: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search functionality
  void onSearchChanged(String query) {
    _searchQuery = query;
    _filteredFoods = _foodRepository.searchFoods(query);
    notifyListeners();
  }

  // Delete food
  Future<void> deleteFood(String foodId) async {
    try {
      await _foodRepository.deleteFood(foodId);
      await loadFoods(); // Refresh the list
    } catch (e) {
      print('Error deleting food: $e');
      rethrow;
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await loadFoods();
  }

  // Get food by ID
  FoodItem? getFood(String id) {
    return _foodRepository.getFood(id);
  }

  // Get total count
  int getTotalFoodCount() {
    return _foodRepository.getTotalFoodCount();
  }
}
