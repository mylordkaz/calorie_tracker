import 'package:flutter/material.dart';
import '../../../data/repositories/repository_factory.dart';
import '../controllers/add_entry_for_date_controller.dart';
import '../widgets/food_library_tab.dart';
import '../widgets/meal_library_tab.dart';
import '../widgets/quick_entry_tab.dart';
import '../../../core/utils/localization_helper.dart';

class AddEntryForDateScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddEntryForDateScreen({required this.selectedDate});

  @override
  _AddEntryForDateScreenState createState() => _AddEntryForDateScreenState();
}

class _AddEntryForDateScreenState extends State<AddEntryForDateScreen> {
  late final AddEntryForDateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddEntryForDateController(
      foodRepository: RepositoryFactory.createFoodRepository(),
      trackingRepository: RepositoryFactory.createTrackingRepository(),
      selectedDate: widget.selectedDate,
    );
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            l10n.addEntryForDate(
              '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: l10n.foods),
              Tab(text: l10n.meals),
              Tab(text: l10n.quickEntry),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            if (_controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            return TabBarView(
              children: [
                FoodLibraryTab(
                  controller: _controller,
                  onEntryAdded: _onEntryAdded,
                ),
                MealLibraryTab(
                  controller: _controller,
                  onEntryAdded: _onEntryAdded,
                ),
                QuickEntryTab(
                  controller: _controller,
                  onEntryAdded: _onEntryAdded,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onEntryAdded(String message) {
    Navigator.pop(context, true); // Return to stats with refresh signal
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
