import 'package:flutter/material.dart';
import 'food_library/screens/food_library_screen.dart';
import 'meal_library/screens/meal_library_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Library'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: 'Foods'),
              Tab(icon: Icon(Icons.local_dining), text: 'Meals'),
            ],
          ),
        ),
        body: TabBarView(children: [FoodLibraryScreen(), MealLibraryScreen()]),
      ),
    );
  }
}
