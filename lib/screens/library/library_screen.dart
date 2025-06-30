import 'package:flutter/material.dart';
import 'food_library_tab.dart';
import 'meal_library_tab.dart';

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
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            tabs: [
              Tab(
                icon: Icon(Icons.restaurant),
                text: 'Foods',
              ),
              Tab(
                icon: Icon(Icons.local_dining),
                text: 'Meals',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FoodLibraryTab(),
            MealLibraryTab(),
          ],
        ),
      ),
    );
  }
}
