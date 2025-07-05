import 'package:flutter/material.dart';
import '../../../../data/repositories/repository_factory.dart';
import '../controllers/meal_library_controller.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_search_bar.dart';
import 'add_meal_screen.dart';
import 'meal_details_screen.dart';

class MealLibraryScreen extends StatefulWidget {
  const MealLibraryScreen({super.key});

  @override
  _MealLibraryScreenState createState() => _MealLibraryScreenState();
}

class _MealLibraryScreenState extends State<MealLibraryScreen> {
  late final MealLibraryController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = MealLibraryController(
      foodRepository: RepositoryFactory.createFoodRepository(),
    );
    _controller.loadMeals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _controller.onSearchChanged(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Search Bar
          MealSearchBar(controller: _searchController),

          // Meals List
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                if (_controller.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }

                if (!_controller.hasSearchResults) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _controller.filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = _controller.filteredMeals[index];
                    return MealCard(
                      meal: meal,
                      onTap: () => _navigateToMealDetails(meal),
                      onToggleFavorite: () =>
                          _controller.toggleMealFavorite(meal.id),
                      calculateMacros: _controller.calculateMealMacros,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: _navigateToAddMeal,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: CircleBorder(),
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_dining_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20),
          Text(
            _controller.isEmpty
                ? 'No meals in your library yet'
                : 'No meals match your search',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _controller.isEmpty
                ? 'Tap the + button to create your first meal'
                : 'Try a different search term',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddMeal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMealScreen()),
    );
    if (result == true) {
      _controller.refresh();
    }
  }

  Future<void> _navigateToMealDetails(meal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealDetailsScreen(meal: meal)),
    );
    if (result == true) {
      _controller.refresh();
    }
  }
}
