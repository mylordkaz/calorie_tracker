import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';

class FoodSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const FoodSearchBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.searchFoods,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
