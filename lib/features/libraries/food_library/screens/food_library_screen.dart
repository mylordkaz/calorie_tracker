import 'package:flutter/material.dart';
import '../../../../data/repositories/repository_factory.dart';
import '../controllers/food_library_controller.dart';
import '../widgets/food_card.dart';
import '../widgets/food_search_bar.dart';
import 'add_food_screen.dart';
import 'food_details_screen.dart';

class FoodLibraryScreen extends StatefulWidget {
  const FoodLibraryScreen({super.key});

  @override
  _FoodLibraryScreenState createState() => _FoodLibraryScreenState();
}

class _FoodLibraryScreenState extends State<FoodLibraryScreen> {
  late final FoodLibraryController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = FoodLibraryController(
      foodRepository: RepositoryFactory.createFoodRepository(),
    );
    _controller.loadFoods();
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
          FoodSearchBar(controller: _searchController),

          // Foods List
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
                  itemCount: _controller.filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = _controller.filteredFoods[index];
                    return FoodCard(
                      food: food,
                      onTap: () => _navigateToFoodDetails(food),
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
          onPressed: _navigateToAddFood,
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
              Icons.restaurant_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20),
          Text(
            _controller.isEmpty
                ? 'No foods in your library yet'
                : 'No foods match your search',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _controller.isEmpty
                ? 'Tap the + button to add your first food'
                : 'Try a different search term',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddFood() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen()),
    );
    if (result == true) {
      _controller.refresh();
    }
  }

  Future<void> _navigateToFoodDetails(food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodDetailsScreen(food: food)),
    );
    if (result == true) {
      _controller.refresh();
    }
  }
}
