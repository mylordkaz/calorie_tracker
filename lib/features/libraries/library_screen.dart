import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_library/screens/food_library_screen.dart';
import 'meal_library/screens/meal_library_screen.dart';
import '../../../../core/utils/localization_helper.dart';
import '../export/export.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final GlobalKey<FoodLibraryScreenState> _foodLibraryKey = GlobalKey();
  final GlobalKey<MealLibraryScreenState> _mealLibraryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return ChangeNotifierProvider(
      create: (_) => ExportController()..setRefreshCallbacks(
        onFoodsUpdated: () => _foodLibraryKey.currentState?.refreshFoods(),
        onMealsUpdated: () => _mealLibraryKey.currentState?.refreshMeals(),
      ),
      child: DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(l10n.library),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [LibraryExportButton()],
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: l10n.foods),
              Tab(icon: Icon(Icons.local_dining), text: l10n.meals),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FoodLibraryScreen(key: _foodLibraryKey),
            MealLibraryScreen(key: _mealLibraryKey),
          ],
        ),
      ),
      ),
    );
  }
}
